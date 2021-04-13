//
//  UserDefaults_App.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 27.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import PrivateDrop_Base

extension UserDefaults {
    var privateDropConfig: PrivateDrop.Configuration? {
        get {
            guard let plist = self.data(forKey: "OpenDropConfig") else { return nil }
            return try? PropertyListDecoder().decode(PrivateDrop.Configuration.self, from: plist)
        }
        set(v) {
            if let config = v,
                let plist = try? PropertyListEncoder().encode(config)
            {
                self.set(plist, forKey: "OpenDropConfig")
                self.synchronize()
            }
        }
    }
}
