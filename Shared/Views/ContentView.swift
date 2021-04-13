//
//  ContentView.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 27.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

enum AvailableViews: String, CaseIterable, Identifiable {
    case senderView
    case receiverView

    var id: String { self.rawValue }
}

struct ContentView: View {
    @EnvironmentObject var testController: TestController
    @EnvironmentObject var psiTest: PSITestController

    var body: some View {
        TabView {
            self.privateDropTests
                .tabItem {
                    Text("PrivateDrop")
                }

            CurveTestingView()
                .tabItem { Text("Curve Test") }
        }
    }

    var privateDropTests: some View {
        VStack {
            Group {
                Picker(selection: self.$testController.role, label: Text("Select view")) {
                    Text("Sender").tag(TestController.Role.sender)
                    Text("Receiver").tag(TestController.Role.receiver)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top)

                Divider()

                if self.testController.role == .sender {
                    SenderStartView()
                } else if self.testController.role == .receiver {
                    ReceiverStartView()
                }

            }.padding([.leading, .trailing])
            Spacer()

        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .frame(width: 480, height: 400)
            .environmentObject(TestController(role: .sender))
    }
}
