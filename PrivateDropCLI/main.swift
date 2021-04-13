//
//  main.swift
//  PrivateDropCLI
//
//  Created by Alex - SEEMOO on 04.11.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import PrivateDrop_Base_Base

func config() throws -> PrivateDrop.Configuration {
    let resourceDirectory = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appendingPathComponent("Shared/Resources")

    let recordData = try Data(contentsOf: resourceDirectory.appendingPathComponent("record.data"))
    let tlsCert = try Data(
        contentsOf: resourceDirectory.appendingPathComponent("ClientCertificate.p12"))

    let signedY = try Data(contentsOf: resourceDirectory.appendingPathComponent("sample_y.cms"))
    let otherPrecomputedVals = try Data(
        contentsOf: resourceDirectory.appendingPathComponent("sample_ids_psi.plist"))

    let config = try PrivateDrop.Configuration(
        recordData: recordData,  // Optional. Necessary for contact identification
        pkcs12: tlsCert,  // TLS certificate
        contactsOnly: true,  // If only contacts are allowed
        contacts: ["491932492424", "john.openseed@example.org"],  // array of contact ids
        signedY: signedY,  // Optional, but necessary for PSI
        otherPrecomputedValues: otherPrecomputedVals  // Optional, but necessary for PSI. pre-computed values
    )

    return config
}

// swiftlint:disable force_try
let privateDropConfig = try! config()

struct ReceiverDelegate: PrivateDropReceiverDelegate {
    func discovered(with status: Peer.Status) {
        print("Discovered peer with \(status)")
    }

    func receivedFiles(at: URL) {
        print("Received file at \(at.path)")
    }

    func receivedAsk(
        request: AskRequestBody, matchingContactId: [String]?,
        userResponse: @escaping (Bool) -> Void
    ) {
        // Ask requests need to be confirmed by the user. `true` if the user wants to receive the file
        userResponse(true)
    }

    func errorOccurred(error: Error) {
        print("An error occurred. Please handle it \(error)")
    }

    func privateDropReady() {
        print("PrivateDrop is ready to receive files")
    }

}

// Receiver
let privateDrop = PrivateDrop(with: privateDropConfig)
let receiverDelegate = ReceiverDelegate()
privateDrop.receiverDelegate = receiverDelegate

try privateDrop.startListening()

//
// let privateDrop = PrivateDrop(with: AppConfiguration.shared.config(with: self.addressBookSize, and: self.role, and: iteration.idsY, and: iteration.idsOther))

struct SenderDelegate: PrivateDropSenderDelegate {
    func found(peer: Peer) {
        print("Found a peer \(peer).\n Now perform contact checks")
        privateDrop.detectContact(for: peer, usePSI: peer.psiStatus != .notSupported)
    }

    func finishedPSI(with peer: Peer) {
        print("Finished psi for peer \(peer)")
    }

    func contactCheckCompleted(receiver: Peer) {
        print("Contact check for peer completed. State: \(receiver.status)")
        // Send sample file
        try! privateDrop.sendFile(
            at: URL(fileURLWithPath: #file).deletingLastPathComponent().appendingPathComponent(
                "owl.png"),
            to: receiver)
    }

    func peerDeclinedFile() {
        print("Peer declined reception of the file ")
    }

    func finishedSending() {
        print("Peer has received the file")
    }

    func errorOccurred(error: Error) {
        print("An error occurred \(error)")
    }

}

// Sender
privateDrop.senderDelegate = SenderDelegate()
privateDrop.browse(privateDropOnly: true)

dispatchMain()
