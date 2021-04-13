//
//  MeasurementEntry.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 28.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation

class MeasurementEntrySender: Codable {

    var startTime: String?

    var Model: String
    var OSVersion: String
    var `Protocol`: TestController.AirDropMode
    var Role: TestController.Role
    var PayloadSize: Float
    var NumberOfContacts: Int
    var NumberOfIDs: Int
    var NumberOfContactsPeer: Int?
    var NumberOfIDsPeer: Int?

    // PSI
    var StartVerifying: String?
    var Verified: String?
    var StartCalculatingV: String?
    var CalculatedV: String?
    var StartIntersecting: String?
    var Intersected: String?
    var StartCalculatingZ: String?
    var CalculatedZ: String?
    var StartCalculatingPOK: String?
    var CalculatedPOK: String?
    var PSICompleted: String?

    var StartedBrowsingBonjour: String?

    var DiscoveredReceiverBonjour: String?

    /// ISO 8601 Date String
    var SendingStartPSIRequest: String?
    /// ISO 8601 Date String
    var ActuallySendingStartPSIRequest: String?
    /// ISO 8601 Date String
    var ReceivedStartPSIResponse: String?
    /// ISO 8601 Date String
    var AuthenticationFinished: String?

    /// ISO 8601 Date String
    var SendingFinishPSIRequest: String?
    /// ISO 8601 Date String
    var ActuallySendingFinishPSIRequest: String?
    var ReceivedFinishPSIResponse: String?

    var SendingDiscoverRequest: String?
    var ActuallySendingDiscoverRequest: String?

    var ReceivedDiscoverResponse: String?

    var StartsSendingFile: String?
    var UploadFinished: String?

    var precomputationDuration: Double?
    var precompute_U_Duration: Double?
    var precompute_ContactHashes_Duration: Double?
    var DiscoverCompleted: String?

    enum CodingKeys: Int, CodingKey, CaseIterable {
        case startTime = 0
        case Model = 1
        case OSVersion = 2
        case `Protocol` = 3
        case Role = 4
        case PayloadSize = 5
        case NumberOfContacts = 6
        case NumberOfIDs = 7
        case NumberOfContactsPeer = 8
        case NumberOfIDsPeer = 9

        // PSI
        case StartVerifying = 10
        case Verified = 11
        case StartCalculatingV = 12
        case CalculatedV = 13
        case StartIntersecting = 14
        case Intersected = 15
        case StartCalculatingZ = 16
        case CalculatedZ = 17
        case StartCalculatingPOK = 18
        case CalculatedPOK = 19
        case PSICompleted = 20

        case StartedBrowsingBonjour = 21
        case DiscoveredReceiverBonjour = 22
        case SendingStartPSIRequest = 23
        case ReceivedStartPSIResponse = 24
        case SendingFinishPSIRequest = 25
        case ReceivedFinishPSIResponse = 26
        case SendingDiscoverRequest = 27
        case ReceivedDiscoverResponse = 28
        case StartsSendingFile = 29
        case UploadFinished = 30
        case precomputationDuration = 31
        case DiscoverCompleted = 32

        case ActuallySendingStartPSIRequest = 33
        case ActuallySendingFinishPSIRequest = 34
        case ActuallySendingDiscoverRequest = 35

        case AuthenticationFinished = 36
        case precompute_U_Duration = 37
        case precompute_ContactHashes_Duration = 38
    }

    static var headers: [String] {
        return CodingKeys.allCases.map({ $0.stringValue })
    }

    init(
        model: String, aDProtocol: TestController.AirDropMode, role: TestController.Role,
        payloadSize: Float, noContacts: Int, noIds: Int
    ) {

        self.Model = model
        self.OSVersion = ProcessInfo().operatingSystemVersionString
        self.Protocol = aDProtocol
        self.Role = role
        self.PayloadSize = payloadSize
        self.NumberOfContacts = noContacts
        self.NumberOfIDs = noIds
    }
}

class MeasurementEntryReceiver: Codable {

    var startTime: String?

    var Model: String
    var OSVersion: String
    var `Protocol`: TestController.AirDropMode
    var Role: TestController.Role
    var PayloadSize: Float
    var NumberOfContacts: Int
    var NumberOfIDs: Int
    var NumberOfContactsPeer: Int?
    var NumberOfIDsPeer: Int?

    // PSI
    var StartVerifying: String?
    var Verified: String?
    var StartCalculatingV: String?
    var CalculatedV: String?
    var StartIntersecting: String?
    var Intersected: String?
    var StartCalculatingZ: String?
    var CalculatedZ: String?
    var StartCalculatingPOK: String?
    var CalculatedPOK: String?
    var PSICompleted: String?

    var ReceivedStartPSIRequest: String?
    var SentStartPSIResponse: String?

    var ReceivedFinishPSIRequest: String?
    var SentFinishPSIResponse: String?
    /// ISO 8601 Date String
    var AuthenticationFinished: String?

    var ReceivedDiscoverRequest: String?
    var SentDiscoverResponse: String?

    var UploadFinished: String?

    var precomputationDuration: Double?
    var precompute_U_Duration: Double?
    var precompute_ContactHashes_Duration: Double?

    enum CodingKeys: Int, CodingKey, CaseIterable {
        case startTime = 0
        case Model = 1
        case OSVersion = 2
        case `Protocol` = 3
        case Role = 4
        case PayloadSize = 5
        case NumberOfContacts = 6
        case NumberOfIDs = 7
        case NumberOfContactsPeer = 8
        case NumberOfIDsPeer = 9

        // PSI
        case StartVerifying = 10
        case Verified = 11
        case StartCalculatingV = 12
        case CalculatedV = 13
        case StartIntersecting = 14
        case Intersected = 15
        case StartCalculatingZ = 16
        case CalculatedZ = 17
        case StartCalculatingPOK = 18
        case CalculatedPOK = 19
        case PSICompleted = 20

        case ReceivedStartPSIRequest = 21
        case SentStartPSIResponse = 22
        case ReceivedFinishPSIRequest = 23
        case SentFinishPSIResponse = 24
        case ReceivedDiscoverRequest = 25
        case SentDiscoverResponse = 26
        case UploadFinished = 27
        case precomputationDuration = 28

        case AuthenticationFinished = 29

        case precompute_U_Duration = 30
        case precompute_ContactHashes_Duration = 31
    }

    static var headers: [String] {
        return CodingKeys.allCases.map({ $0.stringValue })
    }

    init(
        model: String, aDProtocol: TestController.AirDropMode, role: TestController.Role,
        payloadSize: Float, noContacts: Int, noIds: Int
    ) {

        let osVersion = ProcessInfo().operatingSystemVersion

        self.Model = model
        self.OSVersion =
            "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
        self.Protocol = aDProtocol
        self.Role = role
        self.PayloadSize = payloadSize
        self.NumberOfContacts = noContacts
        self.NumberOfIDs = noIds
    }
}

// class MeasurementEntry: Codable {
//    var startTime: String?
//
//    var Model: String
//    var OSVersion: String
//    var `Protocol`: TestController.AirDropMode
//    var PayloadSize: Float
//    var NumberOfContacts: Int
//    var NumberOfIDs: Int
//    var NumberOfContactsPeer: Int?
//    var NumberOfIDsPeer: Int?
//
//    init(model: String, aDProtocol: TestController.AirDropMode, payloadSize: Float, noContacts: Int, noIds: Int) {
//
//        self.Model = model
//        self.OSVersion = ProcessInfo().operatingSystemVersionString
//        self.Protocol = aDProtocol
//        self.PayloadSize = payloadSize
//        self.NumberOfContacts = noContacts
//        self.NumberOfIDs = noIds
//    }
//
//    enum CodingKeys: Int, CodingKey {
//        case startTime = 0
//               case Model = 1
//               case OSVersion = 2
//               case `Protocol` = 3
//               case PayloadSize = 4
//               case NumberOfContacts = 5
//               case NumberOfIDs = 6
//               case NumberOfContactsPeer = 7
//               case NumberOfIDsPeer = 8
//    }
// }
