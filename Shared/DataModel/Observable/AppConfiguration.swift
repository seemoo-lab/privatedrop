//
//  AppConfiguration.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 27.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Combine
import Foundation
import PSI
import PrivateDrop_Base

// swiftlint:disable force_try
class AppConfiguration: ObservableObject {
    static let shared = AppConfiguration()

    private var privateDropConfig: PrivateDrop.Configuration {
        didSet {
            UserDefaults.standard.privateDropConfig = privateDropConfig
        }
    }

    init() {
        // Initialize PSI
        PSI.initialize(config: .init(useECPointCompression: true))

        // Initialize the default config if no values are stored

        //        if let config = UserDefaults.standard.openDropConfig {
        //            self.openDropConfig = config
        //        }else {
        // Generate a new  config
        let bundle = Bundle.main
        guard
            let certificate = try? Data(
                contentsOf: bundle.url(forResource: "ClientCertificate", withExtension: "p12")!),
            let recordData = try? Data(
                contentsOf: bundle.url(forResource: "record", withExtension: "data")!),
            let psiValues = try? Data(
                contentsOf: bundle.url(forResource: "1_other", withExtension: "plist")!),
            let signedY = try? Data(
                contentsOf: bundle.url(forResource: "1_y", withExtension: "cms")!)
        else {
            fatalError("Could not initialize")
        }

        // Check which contacts should be used here
        let privatePSIValues = try! PropertyListDecoder().decode(
            PrivatePSIValues.self, from: psiValues)
        let contacts: [String] = privatePSIValues.ids

        let config = try! PrivateDrop.Configuration(
            recordData: recordData,
            pkcs12: certificate,
            contactsOnly: false,
            contacts: contacts,
            signedY: signedY,
            otherPrecomputedValues: psiValues)

        self.privateDropConfig = config
        //        }
    }

    func config(
        with numberOfContacts: Int? = nil,
        and role: TestController.Role = .sender,
        and idsY: Data? = nil, and idsOther: Data? = nil,
        mode: TestController.AirDropMode
    ) -> PrivateDrop.Configuration {
        let conf = self.privateDropConfig

        let signedY: Data
        let precomputedVals: Data
        var contacts = [String]()

        if let y = idsY,
            let other = idsOther
        {
            signedY = y
            precomputedVals = other
            contacts.append(
                contentsOf: try! PropertyListDecoder().decode(PrivatePSIValues.self, from: other)
                    .ids)
        } else if let y = conf.contacts.signedY,
            let vals = conf.contacts.otherPrecomputedValues
        {
            signedY = y
            precomputedVals = try! PropertyListEncoder().encode(vals)
            contacts.append(contentsOf: vals.ids)

        } else {
            fatalError("Y Values missing")
        }

        if let noOfContacts = numberOfContacts, contacts.count < noOfContacts {
            contacts += AppConfiguration.generateRandomTestSet(of: noOfContacts - contacts.count)
        }

        let certificate: Data

        switch role {
        case .receiver:
            certificate = try! Data(
                contentsOf: Bundle.main.url(forResource: "ServerCertificate", withExtension: "p12")!
            )
        case .sender:
            certificate = try! Data(
                contentsOf: Bundle.main.url(forResource: "ClientCertificate", withExtension: "p12")!
            )
        }

        let newConf = try! PrivateDrop.Configuration(
            recordData: conf.contacts.recordData,
            pkcs12: certificate,
            contactsOnly: conf.contacts.contactsOnly,
            contacts: contacts,
            signedY: signedY,
            otherPrecomputedValues: precomputedVals,
            supportsPrivateDrop: mode == .psi ? true : false
        )

        self.privateDropConfig = newConf

        return newConf
    }

    static func randomString(length: Int) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in letters.randomElement()! })
    }

    static func generateRandomTestSet(of size: Int) -> [String] {
        var testSet = [String]()

        for _ in 0..<size {
            testSet.append(AppConfiguration.randomString(length: 15))
        }

        return testSet
    }

}
