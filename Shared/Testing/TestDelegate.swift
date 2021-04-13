//
//  TestDelegate.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 15.02.21.
//  Copyright © 2021 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import PrivateDrop_Base

/// Extension manages all delegate callbacks for entering measurement points
extension TestController: PrivateDropTestDelegate {

    func authenticationFinished() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.AuthenticationFinished = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.AuthenticationFinished = self.dateFormatter.string(from: Date())
        }
    }

    // MARK: - Receiver

    func psiStartReceived() {
        Log.debug(system: .test, message: "%@", #function)
        self.currentTransmissionUsesPSI = true

        guard let entry = self.currentEntry as? MeasurementEntryReceiver else { return }
        entry.ReceivedStartPSIRequest = self.dateFormatter.string(from: Date())
        entry.Protocol = .psi
    }

    func psiStartSentResponseSent() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntryReceiver else { return }
        entry.SentStartPSIResponse = self.dateFormatter.string(from: Date())
    }

    func psiFinishReceived() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntryReceiver else { return }
        entry.ReceivedFinishPSIRequest = self.dateFormatter.string(from: Date())
    }

    func psiFinishResponseSent() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntryReceiver else { return }
        entry.SentFinishPSIResponse = self.dateFormatter.string(from: Date())
    }

    func discoverReceived() {
        Log.debug(system: .test, message: "%@", #function)

        guard let entry = self.currentEntry as? MeasurementEntryReceiver else { return }
        entry.ReceivedDiscoverRequest = self.dateFormatter.string(from: Date())
    }

    func discoverResponseSent() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntryReceiver else { return }
        entry.SentDiscoverResponse = self.dateFormatter.string(from: Date())
    }

    func fileReceived(size: Int) {
        DispatchQueue.main.async {
            if self.currentTransmissionUsesPSI {
                self.psiAirDropDone += 1
            } else {
                self.classicAirDropDone += 1
            }
            self.currentTransmissionUsesPSI = false

            guard let entry = self.currentEntry as? MeasurementEntryReceiver else { return }
            entry.UploadFinished = self.dateFormatter.string(from: Date())
            entry.PayloadSize = Float(size)

            // Add entry to measurements
            self.measurements.append(entry)
            Log.debug(system: .test, message: "File received")

            if let iterations = self.iterations,
                iterations.isEmpty == false
            {
                // One iteration is done
                self.iterationsCompleted += 1
                self.startNextIteration()
            } else {
                self.stopTests()
            }
        }
    }

    // MARK: - PSI

    func startVerifying() {

        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.StartVerifying = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.StartVerifying = self.dateFormatter.string(from: Date())
        }
    }

    func verified() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.Verified = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.Verified = self.dateFormatter.string(from: Date())
        }
    }

    func startCalculatingV() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.StartCalculatingV = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.StartCalculatingV = self.dateFormatter.string(from: Date())
        }
    }

    func calculatedV() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.CalculatedV = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.CalculatedV = self.dateFormatter.string(from: Date())
        }
    }

    func startCalculatingZ() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.StartCalculatingZ = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.StartCalculatingZ = self.dateFormatter.string(from: Date())
        }
    }

    func startCalculatingPOK() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.StartCalculatingPOK = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.StartCalculatingPOK = self.dateFormatter.string(from: Date())
        }
    }

    func calculatedZ() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.CalculatedZ = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.CalculatedZ = self.dateFormatter.string(from: Date())
        }
    }

    func startIntersecting() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.StartIntersecting = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.StartIntersecting = self.dateFormatter.string(from: Date())
        }
    }

    func intersected() {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.Intersected = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.Intersected = self.dateFormatter.string(from: Date())
        }
    }

    func calculatedPOK() {

        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.CalculatedPOK = self.dateFormatter.string(from: Date())
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.CalculatedPOK = self.dateFormatter.string(from: Date())
        }
    }

    func PSICompleted(peerContacts: Int, peerIds: Int) {
        Log.debug(system: .test, message: "%@", #function)
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.PSICompleted = self.dateFormatter.string(from: Date())
            entry.NumberOfIDsPeer = peerIds
            entry.NumberOfContactsPeer = peerContacts

        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.PSICompleted = self.dateFormatter.string(from: Date())
            entry.NumberOfIDsPeer = peerIds
            entry.NumberOfContactsPeer = peerContacts
        }
    }

    func precomputeUDuration(time: TimeInterval) {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.precompute_U_Duration = time
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.precompute_U_Duration = time
        }
    }

    func precomputeContactHashesDuration(time: TimeInterval) {
        if let entry = self.currentEntry as? MeasurementEntrySender {
            entry.precompute_ContactHashes_Duration = time
        } else if let entry = self.currentEntry as? MeasurementEntryReceiver {
            entry.precompute_ContactHashes_Duration = time
        }
    }

    func startedBrowsing() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.StartedBrowsingBonjour = self.dateFormatter.string(from: Date())
    }

    func sendingPSIStart() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.SendingStartPSIRequest = self.dateFormatter.string(from: Date())
    }

    func actuallySendingPSIStart() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.ActuallySendingStartPSIRequest = self.dateFormatter.string(from: Date())
    }

    func receivedPSIStartResponse() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.ReceivedStartPSIResponse = self.dateFormatter.string(from: Date())
    }

    func sendingPSIFinish() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.SendingFinishPSIRequest = self.dateFormatter.string(from: Date())
    }

    func actuallySendingPSIFinish() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.ActuallySendingFinishPSIRequest = self.dateFormatter.string(from: Date())
    }

    func receivedPSIFinish() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.ReceivedFinishPSIResponse = self.dateFormatter.string(from: Date())
    }

    func sendingDiscoverRequest() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.SendingDiscoverRequest = self.dateFormatter.string(from: Date())
    }

    func actuallySendingDiscoverRequest() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.ActuallySendingDiscoverRequest = self.dateFormatter.string(from: Date())
    }

    func receivedDiscoverResponse() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.ReceivedDiscoverResponse = self.dateFormatter.string(from: Date())
    }

    func startsSendingFile() {
        Log.debug(system: .test, message: "%@", #function)
        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.StartsSendingFile = self.dateFormatter.string(from: Date())
    }

    func fileSent(payloadSize: Int) {
        guard self.testIsRunning else { return }
        print("Upload finished")
        Log.debug(system: .test, message: "Upload finished")

        guard let entry = self.currentEntry as? MeasurementEntrySender else { return }
        entry.UploadFinished = self.dateFormatter.string(from: Date())
        entry.PayloadSize = Float(payloadSize)

        DispatchQueue.main.async {
            // Update counter
            switch self.mode {
            case .original:
                self.classicAirDropDone += 1
            case .psi:
                self.psiAirDropDone += 1
            }

            self.restartSending()

        }

    }
}
