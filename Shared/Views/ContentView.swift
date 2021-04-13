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
    @State var selectedToolbarItem = 0

    var body: some View {
        #if os(macOS)
            Group {
                if selectedToolbarItem == 0 {
                    self.privateDropTests
                } else {
                    CurveTestingView()
                }
            }
            .toolbar(content: {
                self.toolbar
            })
            .navigationTitle(Text("PrivateDrop testing"))

        #else
            TabView {
                self.privateDropTests
                    .tabItem {
                        Image(systemName: "wifi")
                        Text("PrivateDrop")
                    }

                CurveTestingView()
                    .tabItem {
                        Image(systemName: "target")
                        Text("Curve Test")
                    }
            }
        #endif
    }

    var toolbar: some ToolbarContent {
        Group {
            ToolbarItemGroup {
                Button(
                    action: {
                        self.selectedToolbarItem = 0
                    },
                    label: {
                        HStack {
                            Image(systemName: "wifi")
                            Text("PrivateDrop")
                        }
                    })

                Button(
                    action: {
                        self.selectedToolbarItem = 1
                    },
                    label: {
                        HStack {
                            Image(systemName: "target")
                            Text("Curve Test")
                        }
                    })
            }
        }
    }

    var privateDropTests: some View {
        VStack {
            Group {
                Picker(selection: self.$testController.role, label: Text("Select role")) {
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
