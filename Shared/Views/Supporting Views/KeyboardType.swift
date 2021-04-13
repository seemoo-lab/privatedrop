//
//  KeyboardType.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 12.10.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import SwiftUI

extension View {
    func numberKeyboard() -> some View {
        #if canImport(UIKit)
            return self.keyboardType(.numberPad)
        #else
            return self
        #endif

    }
}

extension View {
    func hideKeyboard() {
        #if canImport(UIKit)
            UIApplication.shared.sendAction(
                #selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        #endif
    }
}
