//
//  PSITestController.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 31.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import CodableCSV
import Combine
import Foundation
import PSI

#if canImport(UIKit)
    import UIKit
#endif

#if canImport(IOKit) && canImport(AppKit)
    import IOKit
    import AppKit
#endif

class PSITestController: ObservableObject {

    @Published var testIsRunning = false
    @Published var addressbookSizeString = "1000"
    @Published var numberOfIdsString = "5"
    @Published var numberOfTestsString = "10"
    @Published var progress: Float = 0

    @Published var testDone = 0 {
        didSet {
            self.progress = Float(testDone) / Float(numberOfTests)
        }
    }

    var verifier: Verifier?
    var prover: Prover?
    var u: [Data]?
    var y: [Data]?

    var measurements: [MeasurementEntryPSI] = []
    var currentMeasurement: MeasurementEntryPSI?
    @Published var exportedFileURL: URL?

    var addressBookSize: Int {
        return Int(addressbookSizeString) ?? 1000
    }

    var numberOfTests: Int {
        return Int(numberOfTestsString) ?? 1
    }

    var numberOfIds: Int {
        return Int(self.numberOfIdsString) ?? 5
    }

    var dateFormatter: ISO8601DateFormatter

    init() {
        self.dateFormatter = ISO8601DateFormatter()
        self.dateFormatter.formatOptions = [
            .withFullDate, .withFullTime, .withTimeZone, .withFractionalSeconds,
        ]
    }

    func currentModel() -> String {
        #if os(iOS)
            var systemInfo = utsname()
            uname(&systemInfo)
            let modelCode = withUnsafePointer(to: &systemInfo.machine) {
                $0.withMemoryRebound(to: CChar.self, capacity: 1) { ptr in
                    String.init(validatingUTF8: ptr)
                }
            }
            return modelCode ?? "iOS"
        #elseif os(macOS)
            let service = IOServiceGetMatchingService(
                kIOMasterPortDefault,
                IOServiceMatching("IOPlatformExpertDevice"))
            var modelIdentifier: String?

            if let modelData = IORegistryEntryCreateCFProperty(
                service, "model" as CFString, kCFAllocatorDefault, 0
            ).takeRetainedValue() as? Data {
                if let modelIdentifierCString = String(data: modelData, encoding: .utf8)?.cString(
                    using: .utf8)
                {
                    modelIdentifier = String(cString: modelIdentifierCString)
                }
            }

            IOObjectRelease(service)
            return modelIdentifier ?? ""
        #endif
    }

    func startTests() {
        PSI.initialize(config: .init(useECPointCompression: true))
        self.testIsRunning = true
        self.testDone = 0
        self.measurements = []

        let psiQueue = DispatchQueue(
            label: "PSI Testing", qos: .userInitiated, attributes: .init(),
            autoreleaseFrequency: .workItem, target: nil)

        psiQueue.async {
            do {
                // Initialize
                let ids = AppConfiguration.generateRandomTestSet(of: self.numberOfIds)
                self.verifier = try Verifier(ids: ids)
                // this value is pre-computed in PrivateDrop execution
                self.y = self.verifier?.generateYFromIds()

                let contacts = AppConfiguration.generateRandomTestSet(of: self.addressBookSize)
                self.prover = try Prover(contacts: contacts)
                let startU = Date()
                // This value is pre-computed in PrivateDrop
                self.u = self.prover?.generateUForVerifier()
                let precomputeTime = Date().timeIntervalSince1970 - startU.timeIntervalSince1970

                for _ in 0..<self.numberOfTests {
                    try self.executePSI(precomputeTime: precomputeTime)
                    DispatchQueue.main.sync {
                        self.testDone += 1
                    }
                }

            } catch {
                DispatchQueue.main.async {
                    self.testIsRunning = false
                }

                return
            }
            DispatchQueue.main.async {
                self.testIsRunning = false
                self.generateExportMeasurements()
            }

        }

    }

    func executePSI(precomputeTime: TimeInterval) throws {

        let model: String = self.currentModel()
        let osVersion = ProcessInfo().operatingSystemVersion
        let osVersionString =
            "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        self.currentMeasurement = MeasurementEntryPSI(
            model: model, osVersion: osVersionString, peerContacts: self.addressBookSize,
            ids: self.numberOfIds)
        self.currentMeasurement?.PrecomputingTime = precomputeTime

        // Execute PSI

        self.currentMeasurement?.startTime = self.dateFormatter.string(from: Date())
        self.currentMeasurement?.StartCalculatingZ = self.dateFormatter.string(from: Date())
        let z = self.prover!.generateZValuesForVerifier(from: self.y!)
        self.currentMeasurement?.CalculatedZ = self.dateFormatter.string(from: Date())
        self.currentMeasurement?.StartCalculatingPOK = self.dateFormatter.string(from: Date())
        let (pokAs, pokZ) = self.prover!.generatePoKForVerifier(from: self.y!, z: z)
        self.currentMeasurement?.CalculatedPOK = self.dateFormatter.string(from: Date())
        self.currentMeasurement?.StartVerifying = self.dateFormatter.string(from: Date())
        let zECC = z.map(ECC.readPoint(from:))
        let pokAsBN = pokAs.map(ECC.readPoint(from:))
        let pokZBN = BN.bigNumberFromBinary(data: pokZ)
        try self.verifier!.verifyPOK(z: zECC, pokZ: pokZBN, pokAs: pokAsBN)
        self.currentMeasurement?.Verified = self.dateFormatter.string(from: Date())
        self.currentMeasurement?.StartCalculatingV = self.dateFormatter.string(from: Date())
        self.verifier!.calculateV(z: zECC)
        self.currentMeasurement?.CalculatedV = self.dateFormatter.string(from: Date())
        self.currentMeasurement?.StartIntersecting = self.dateFormatter.string(from: Date())
        _ = self.verifier!.intersect(with: self.u!)
        self.currentMeasurement?.intersected = self.dateFormatter.string(from: Date())

        self.measurements.append(self.currentMeasurement!)
    }

    func generateExportMeasurements() {
        let encoder = CSVEncoder()

        var csvFile: Data = Data()

        encoder.headers = MeasurementEntryPSI.headers
        // swiftlint:disable force_try
        csvFile = try! encoder.encode(measurements)

        // Write to cache folder
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
        let df = DateFormatter()
        df.dateFormat = "dd.MM.yy"
        // File name format
        // PSI-NoOfTests-NoOfContacts-NoOfIds
        let filename =
            "PSI-\(measurements.count)-\(addressBookSize)-\(numberOfIds)-\(df.string(from: Date()))"
        let fileURL = cacheDirectory.appendingPathComponent("\(filename).csv")

        try! csvFile.write(to: fileURL)

        DispatchQueue.main.async {
            #if os(iOS)
                self.exportedFileURL = fileURL
            #elseif os(macOS)
                SavePanel().saveFile(
                    file: csvFile, fileExtension: "csv", nameFieldLabel: "CSV Export",
                    filename: filename)
            #endif
        }

    }
}
