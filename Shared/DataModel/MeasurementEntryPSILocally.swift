//
//  MeasurementEntryPSILocally.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 31.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation

class MeasurementEntryPSI: Codable {
    var startTime: String?
    var Model: String
    var OSVersion: String
    var NumberOfContactsPeer: Int
    var NumberOfIDs: Int

    // Y-Values are imported. So do not measure them
    var PrecomputingTime: Double?

    var StartCalculatingZ: String?
    var CalculatedZ: String?
    var StartCalculatingPOK: String?
    var CalculatedPOK: String?
    var StartVerifying: String?
    var Verified: String?
    var StartCalculatingV: String?
    var CalculatedV: String?
    var StartIntersecting: String?
    var intersected: String?

    enum CodingKeys: Int, CodingKey, CaseIterable {
        case startTime = 0
        case Model = 1
        case OSVersion = 2
        case NumberOfContactsPeer = 3
        case NumberOfIDs = 4

        case PrecomputingTime = 5

        case StartCalculatingZ = 6
        case CalculatedZ = 7
        case StartCalculatingPOK = 8
        case CalculatedPOK = 9
        case StartVerifying = 10
        case Verified = 11
        case StartCalculatingV = 12
        case CalculatedV = 13
        case StartIntersecting = 14
        case intersected = 15

    }

    static var headers: [String] {
        return CodingKeys.allCases.map({ $0.stringValue })
    }

    init(model: String, osVersion: String, peerContacts: Int, ids: Int) {
        self.Model = model
        self.OSVersion = osVersion
        self.NumberOfContactsPeer = peerContacts
        self.NumberOfIDs = ids
    }

}
