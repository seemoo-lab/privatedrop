//
//  PrivateDropApp.swift
//  PrivateDrop Mac
//
//  Created by Alex - SEEMOO on 13.04.21.
//  Copyright © 2021 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import SwiftUI

@main
struct PrivateDropApp: App {
    @StateObject var testController = TestController(role: .sender)
    @StateObject var psiTest = PSITestController()
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(self.testController)
                .environmentObject(self.psiTest)
                .frame(minWidth: 640, minHeight: 500)
        }
        .commands {
            SidebarCommands()
        }
        .windowToolbarStyle(UnifiedWindowToolbarStyle(showsTitle: true))
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidBecomeActive(_ notification: Notification) {
        NSApplication.shared.mainWindow?.level = .floating
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
