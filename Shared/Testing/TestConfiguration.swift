//
//  TestConfiguration.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 10.08.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation

struct TestConfiguration {

    let fileSize: Float
    let numberOfTests: Int
    let addressbookSize: Int

    let idsY: Data?
    let idsOther: Data?
    let transmissionMode: TestController.AirDropMode

    static let defaultTests = [
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 100, idsY: idsY(with: 1),
            idsOther: other(with: 1), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 100, idsY: idsY(with: 10),
            idsOther: other(with: 10), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 100, idsY: idsY(with: 20),
            idsOther: other(with: 20), transmissionMode: .psi),

        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 1000, idsY: idsY(with: 1),
            idsOther: other(with: 1), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 1000, idsY: idsY(with: 10),
            idsOther: other(with: 10), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 1000, idsY: idsY(with: 20),
            idsOther: other(with: 20), transmissionMode: .psi),

        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 5000, idsY: idsY(with: 1),
            idsOther: other(with: 1), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 5000, idsY: idsY(with: 10),
            idsOther: other(with: 10), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 5000, idsY: idsY(with: 20),
            idsOther: other(with: 20), transmissionMode: .psi),

        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 10000, idsY: idsY(with: 1),
            idsOther: other(with: 1), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 10000, idsY: idsY(with: 10),
            idsOther: other(with: 10), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 10000, idsY: idsY(with: 20),
            idsOther: other(with: 20), transmissionMode: .psi),

        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 15000, idsY: idsY(with: 1),
            idsOther: other(with: 1), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 15000, idsY: idsY(with: 10),
            idsOther: other(with: 10), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 15000, idsY: idsY(with: 20),
            idsOther: other(with: 20), transmissionMode: .psi),
    ]

    static let airDropOnlyTests = [
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 100, idsY: idsY(with: 1), idsOther: other(with: 1), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 100, idsY: idsY(with: 10), idsOther: other(with: 10), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 100, idsY: idsY(with: 20), idsOther: other(with: 20), transmissionMode:.original),

        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 1000, idsY: idsY(with: 1), idsOther: other(with: 1), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 1000, idsY: idsY(with: 10), idsOther: other(with: 10), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 1000, idsY: idsY(with: 20), idsOther: other(with: 20), transmissionMode:.original),
        //
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 5000, idsY: idsY(with: 1), idsOther: other(with: 1), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 5000, idsY: idsY(with: 10), idsOther: other(with: 10), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 5000, idsY: idsY(with: 20), idsOther: other(with: 20), transmissionMode:.original),
        //
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 10000, idsY: idsY(with: 1), idsOther: other(with: 1), transmissionMode:.original),
        TestConfiguration(
            fileSize: 10, numberOfTests: 1, addressbookSize: 10000, idsY: idsY(with: 10),
            idsOther: other(with: 10), transmissionMode: .original)
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 10000, idsY: idsY(with: 20), idsOther: other(with: 20), transmissionMode:.original),
        //
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 15000, idsY: idsY(with: 1), idsOther: other(with: 1), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 15000, idsY: idsY(with: 10), idsOther: other(with: 10), transmissionMode:.original),
        //        TestConfiguration(fileSize: 10, numberOfTests: 1, addressbookSize: 15000, idsY: idsY(with: 20), idsOther: other(with: 20), transmissionMode:.original),
    ]

    static let allTests = defaultTests + airDropOnlyTests

    static let largeIdSet = [
        TestConfiguration(
            fileSize: 10, numberOfTests: 10, addressbookSize: 1000, idsY: idsY(with: 100),
            idsOther: other(with: 100), transmissionMode: .psi),
        TestConfiguration(
            fileSize: 10, numberOfTests: 10, addressbookSize: 1000, idsY: idsY(with: 1000),
            idsOther: other(with: 1000), transmissionMode: .psi),
    ]

    // swiftlint:disable force_try
    /// Returns the ids cms file with the number of ids specified.
    ///
    /// Check the Resources folder to see which are available. The application will crash if the number is not available
    /// - Parameter number: The amount of ids that should be in the file
    /// - Returns: Binary data for the Y CMS
    static func idsY(with number: Int) -> Data {
        let url = Bundle.main.url(forResource: "\(number)_y", withExtension: "cms")!
        return try! Data(contentsOf: url)
    }

    /// Returns the ids plist file with the number of ids specified.
    ///
    /// Check the Resources folder to see which are available. The application will crash if the number is not available
    /// - Parameter number: The amount of ids that should be in the file
    /// - Returns: Binary data for the other values plist
    static func other(with number: Int) -> Data {
        let url = Bundle.main.url(forResource: "\(number)_other", withExtension: "plist")!
        return try! Data(contentsOf: url)
    }
}
