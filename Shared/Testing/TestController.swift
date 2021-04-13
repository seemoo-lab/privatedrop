//
//  TestController.swift
//  PrivateDropApp
//
//  Created by Alex - SEEMOO on 28.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import CodableCSV
import Combine
import Foundation
import Network
import PrivateDrop_Base

// swiftlint:disable force_try
class TestController: NSObject, ObservableObject, PrivateDropSenderDelegate {

    @Published var role: Role
    var mode: AirDropMode = .psi

    var privateDrop: PrivateDrop?
    var currentTransmissionUsesPSI = false

    var dateFormatter: ISO8601DateFormatter

    @Published var classicAirDropDone = 0 {
        didSet {
            let classicProgress = Float(self.classicAirDropDone) / Float(self.numberOfTests)
            let psiProgress = Float(self.psiAirDropDone) / Float(self.numberOfTests)
            self.progress = classicProgress * 0.5 + psiProgress * 0.5
        }
    }

    @Published var psiAirDropDone = 0 {
        didSet {
            let classicProgress = Float(self.classicAirDropDone) / Float(self.numberOfTests)
            let psiProgress = Float(self.psiAirDropDone) / Float(self.numberOfTests)
            self.progress = classicProgress * 0.5 + psiProgress * 0.5
        }
    }

    /// Completed iterations for the iterative testing
    @Published var iterationsCompleted = 0

    @Published var testIsRunning = false

    // MARK: Test Config
    @Published var fileSize: Float = 10
    @Published var numberOfTestsString = "10"
    @Published var addressbookSizeString = "1000"
    @Published var progress: Float = 0

    // MARK: Consecutive Tests

    @Published var iterations: [TestConfiguration]?

    /// If true. The TestController will send a Discover request as part of the AirDrop protocol even when using PSI. Otherwise it will not
    var sendDiscoverIfPSI = false

    // MARK: Errors

    @Published var error: Error?
    @Published var showError: Bool = false

    @Published var state: TestState = .precomputing

    var addressBookSize: Int {
        return Int(addressbookSizeString) ?? 1000
    }

    var numberOfTests: Int {
        return Int(numberOfTestsString) ?? 1
    }

    var currentClientPeer: Peer?
    var testFileURL: URL?

    // MARK: Test Measurements
    var measurements: [Any] = []
    var currentEntry: Any?

    @Published var exportedFileURL: URL?

    // MARK: - Functions
    init(role: Role) {
        self.role = role
        self.dateFormatter = ISO8601DateFormatter()
        self.dateFormatter.formatOptions = [
            .withFullDate, .withFullTime, .withTimeZone, .withFractionalSeconds,
        ]
    }

    // MARK: Test starting

    func runTests(testSuite: [TestConfiguration] = TestConfiguration.defaultTests) {
        self.iterations = testSuite
        self.testIsRunning = true
        self.measurements = []

        self.startNextIteration()
    }

    /// Run the next test iteration from the current suite
    internal func startNextIteration() {

        self.state = .precomputing
        self.psiAirDropDone = 0
        self.classicAirDropDone = 0

        let iteration = self.iterations!.removeFirst()
        Log.debug(system: .test, message: "New itartion. %d contacts", iteration.addressbookSize)
        self.mode = iteration.transmissionMode

        self.addressbookSizeString = "\(iteration.addressbookSize)"
        self.numberOfTestsString = "\(iteration.numberOfTests)"
        self.fileSize = iteration.fileSize

        self.testFileURL = self.generateTestFile()

        if let active = self.privateDrop {
            active.stopBrowsing()
            active.stopListening()
        }

        let config = AppConfiguration.shared.config(
            with: self.addressBookSize, and: self.role, and: iteration.idsY,
            and: iteration.idsOther,
            mode: self.mode)
        self.privateDrop = PrivateDrop(with: config)

        let precomputationStarted = Date()
        self.privateDrop?.precomputeContactValues {
            let precomputationTime = Date().timeIntervalSince(precomputationStarted)
            self.generateCurrentEntry(with: self.privateDrop!.configuration)
            Log.debug(system: .test, message: "Precomputation took %2.f s", precomputationTime)

            if let entry = self.currentEntry as? MeasurementEntryReceiver {
                entry.precomputationDuration = precomputationTime
            } else if let entry = self.currentEntry as? MeasurementEntrySender {
                entry.precomputationDuration = precomputationTime
            }

            self.startPrivateDrop()

        }
    }

    /// Launcht the opendrop receiver or sender depending on the current configuration. Called from `startNextIteration`
    private func startPrivateDrop() {

        switch self.role {
        case .receiver:

            // Setup an PrivateDrop and start listening
            // Add the necessary delegates to measure testing times
            PrivateDrop.testDelegate = self
            self.state = .serverSetup
            self.privateDrop?.receiverDelegate = self

            let port = 8443 + self.iterationsCompleted
            try! self.privateDrop?.startListening(port: port)
        case .sender:

            PrivateDrop.testDelegate = self
            self.state = .senderWaiting
            self.privateDrop?.senderDelegate = self

            // Needs to wait, because the server is starting up
            Log.debug(system: .test, message: "Waiting 5s for server setup")
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.state = .sending
                // Start the tests
                self.privateDrop?.browse(privateDropOnly: false)
            }
        }
    }

    func stopTests() {
        switch role {
        case .receiver:
            self.privateDrop?.stopListening()
        case .sender:
            self.privateDrop?.stopBrowsing()
        }

        self.testIsRunning = false

        // Export measurements
        self.generateExportMeasurements()

    }

    func restartSending() {
        guard let measurement = self.currentEntry else {
            fatalError("Should not reach this state")
        }

        self.measurements.append(measurement)

        if let iterations = self.iterations,
            iterations.isEmpty == false
        {
            // Start the next iteration
            self.iterationsCompleted += 1
            self.startNextIteration()
            return
        } else {
            self.stopTests()
            return
        }

    }

    func generateCurrentEntry(with config: PrivateDrop.Configuration) {
        switch role {
        case .receiver:

            let entry = MeasurementEntryReceiver(
                model: config.general.modelName,
                aDProtocol: .original,
                role: self.role,
                payloadSize: self.fileSize * 1024 * 1024,
                noContacts: self.addressBookSize,
                noIds: config.contacts.otherPrecomputedValues?.ids.count ?? 0)
            entry.startTime = dateFormatter.string(from: Date())
            self.currentEntry = entry
        case .sender:
            let entry = MeasurementEntrySender(
                model: config.general.modelName,
                aDProtocol: self.mode,
                role: self.role,
                payloadSize: self.fileSize,
                noContacts: self.addressBookSize,
                noIds: config.contacts.otherPrecomputedValues?.ids.count ?? 0)

            entry.startTime = dateFormatter.string(from: Date())
            self.currentEntry = entry
        }

    }

    func generateTestFile() -> URL {
        // Generate a test file with the specified size
        let documentsDir = FileManager.default.urls(for: .cachesDirectory, in: .allDomainsMask)
            .first!

        let testFileURL = documentsDir.appendingPathComponent("OpenDropTestFile.data")

        try? FileManager.default.removeItem(at: testFileURL)
        FileManager.default.createFile(atPath: testFileURL.path, contents: nil, attributes: nil)
        let file = try! FileHandle(forWritingTo: testFileURL)
        var fileSize = file.seekToEndOfFile()

        let expectedFileSize = UInt64(self.fileSize * 1024 * 1024)

        while fileSize < expectedFileSize {
            // Generate Strings with 1MB Length
            var bytes = [UInt8](repeating: 0, count: 1024 * 1024)
            arc4random_buf(&bytes, bytes.count)

            let randomData = Data(bytes)
            fileSize += UInt64(randomData.count)
            file.write(randomData)

        }

        try! file.close()

        return testFileURL
    }

    func generateExportMeasurements() {
        let encoder = CSVEncoder()

        var csvFile: Data = Data()
        if let measurements = self.measurements as? [MeasurementEntrySender] {
            encoder.headers = MeasurementEntrySender.headers
            csvFile = try! encoder.encode(measurements)
        } else if let measurements = self.measurements as? [MeasurementEntryReceiver] {
            encoder.headers = MeasurementEntryReceiver.headers
            csvFile = try! encoder.encode(measurements)
        }

        // Write to cache folder
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
        let df = DateFormatter()
        df.dateFormat = "YYYY-MM-dd hh:mm"
        let filename = "\(df.string(from: Date()))-\(self.role.rawValue)"
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

    // MARK: - Sender

    func found(peer: Peer) {
        guard self.testIsRunning else { return }
        // Perform PSI or discover

        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.DiscoveredReceiverBonjour = self.dateFormatter.string(from: Date())
        Log.debug(system: .test, message: "Discovered Receiver Bonjour")

        self.privateDrop?.stopBrowsing()
        self.privateDrop?.detectContact(for: peer, usePSI: self.mode == .psi)
    }

    func contactCheckCompleted(receiver: Peer) {
        guard self.testIsRunning else { return }
        // Send file
        Log.debug(system: .test, message: "Contact check completed")

        guard let fileURL = self.testFileURL else { return }
        try! self.privateDrop?.sendFile(at: fileURL, to: receiver)

        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }

        entry.DiscoverCompleted = self.dateFormatter.string(from: Date())
    }

    func finishedPSI(with peer: Peer) {
        guard self.testIsRunning else { return }
        print("PSI finished")

        if self.sendDiscoverIfPSI {
            self.privateDrop?.discover(peer: peer)
        }
    }

    func finishedSending() {
    }

    func peerDeclinedFile() {

    }

    // MARK: - Error handling

    func errorOccurred(error: Error) {
        DispatchQueue.main.async {
            self.stopTests()

            self.error = error
            self.showError = true
        }
    }
}

extension TestController {
    enum Role: String, CaseIterable, Identifiable, Codable {
        case sender
        case receiver

        var id: String { self.rawValue }
    }

    enum AirDropMode: String, Codable, Identifiable {
        case original
        case psi

        var id: String { return self.rawValue }
    }

    enum TestState {
        case precomputing
        case serverSetup
        case receiving

        case senderWaiting
        case sending

    }
}

extension URL: Identifiable {
    public var id: Int {
        return self.absoluteString.hashValue
    }
}

// MARK: - PrivateDrop receiver delegate
extension TestController: PrivateDropReceiverDelegate {
    func discovered(with status: Peer.Status) {

    }

    func discovered() {

    }

    func receivedFiles(at: URL) {

    }

    func receivedAsk(
        request: AskRequestBody, matchingContactId: [String]?,
        userResponse: @escaping (Bool) -> Void
    ) {

        // For testing we always accept the ask request
        userResponse(true)
    }

    func privateDropReady() {
        // The server has started. Launch the test service
        // self.publishTestReadyService()
        Log.debug(system: .test, message: "PrivateDrop is ready to receive")
        self.state = .receiving
    }

}
