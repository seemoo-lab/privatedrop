//
//  ReceiverTestView.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 27.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

struct ReceiverStartView: View {
    @EnvironmentObject var testController: TestController

    @State var showSheet = false

    @State var testMode: TestController.AirDropMode = .psi

    @State var ids: Int = 0
    let idsArray = [1, 5, 10, 20, 100, 1000]

    @State var fileSize: Float = 10
    @State var numberOfTests = "10"
    @State var addressBookSize = "1000"

    var body: some View {
        VStack {

            HStack {
                Text("Number of tests")
                    .bold()
                Spacer()
            }

            Stepper(
                onIncrement: {
                    if var numberOfTests = Int(self.numberOfTests) {
                        numberOfTests += 1
                        self.numberOfTests = "\(numberOfTests)"
                    }

                },
                onDecrement: {
                    if var numberOfTests = Int(self.numberOfTests) {
                        numberOfTests -= 1
                        self.numberOfTests = "\(numberOfTests)"
                    }
                },
                label: {
                    TextField("", text: self.$numberOfTests)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    .numberKeyboard()

                })

            HStack {
                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)

                Text("Single test setup")

                Rectangle()
                    .fill(Color.gray)
                    .frame(height: 1)
            }

            HStack {
                Text("Addressbook size")
                    .bold()
                Spacer()
            }

            Stepper(
                onIncrement: {
                    if var bookSize = Int(self.addressBookSize) {
                        bookSize += 1
                        self.addressBookSize = "\(bookSize)"
                    }

                },
                onDecrement: {
                    if var bookSize = Int(self.addressBookSize) {
                        bookSize += 1
                        self.addressBookSize = "\(bookSize)"
                    }
                },
                label: {

                    TextField("", text: self.$addressBookSize)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    //                    .numberKeyboard()

                })

            self.pickers

            Spacer()

            self.buttons

        }
        .sheet(isPresented: self.$showSheet) {
            if self.testController.exportedFileURL == nil {
                ReceiverTestingView()
                    .environmentObject(self.testController)
            } else {
                #if os(iOS)
                    SwiftUIActivityController(with: [self.testController.exportedFileURL!]) {
                        (_, _, _, _) in
                        try? FileManager.default.removeItem(
                            at: self.testController.exportedFileURL!)
                        self.testController.exportedFileURL = nil
                        self.showSheet = false
                    }
                #endif
            }
        }
    }

    var pickers: some View {
        Group {
            Picker("Mode", selection: self.$testMode) {
                Text("AirDrop-Original").tag(TestController.AirDropMode.original)
                Text("PSI").tag(TestController.AirDropMode.psi)
            }
            .pickerStyle(SegmentedPickerStyle())

            Picker("Ids", selection: self.$ids) {
                ForEach(0..<idsArray.count) { (i) in
                    Text("\(idsArray[i])").tag(i)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }

    var buttons: some View {

        VStack {
            Button(
                action: {

                    let noTests = Int(self.numberOfTests)!
                    let addressBookSize = Int(self.addressBookSize)!

                    let testConfig = TestConfiguration(
                        fileSize: self.fileSize, numberOfTests: 1,
                        addressbookSize: addressBookSize,
                        idsY: TestConfiguration.idsY(with: self.idsArray[self.ids]),
                        idsOther: TestConfiguration.other(with: self.idsArray[self.ids]),
                        transmissionMode: self.testMode)

                    let tests = Array(repeating: [testConfig], count: noTests).flatMap({ $0 })

                    self.testController.runTests(testSuite: tests)

                    self.showSheet.toggle()

                },
                label: {
                    Text("Run single Tests")
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing])
                        .foregroundColor(.accentColor)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                .stroke(Color.gray)
                        )
                }
            )
            .buttonStyle(PlainButtonStyle())

            Rectangle()
                .fill(Color.gray)
                .frame(height: 1)
                .padding(.bottom)

            // Execute both sequentially
            Button(
                action: {
                    let testSuite = Array(
                        repeating: TestConfiguration.allTests, count: Int(self.numberOfTests)!
                    ).flatMap({ $0 })

                    self.testController.runTests(testSuite: testSuite)
                    self.showSheet.toggle()

                },
                label: {
                    Text("Start PrivateDrop & AirDrop")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                .fill(Color.gray)
                        )
                }
            )
            .buttonStyle(PlainButtonStyle())
            .padding()

            HStack {
                Spacer()

                Button(
                    action: {

                        let testSuite = Array(
                            repeating: TestConfiguration.defaultTests, count: Int(self.numberOfTests)!
                        ).flatMap({ $0 })

                        self.testController.runTests(testSuite: testSuite)
                        self.showSheet.toggle()
                    },
                    label: {
                        Text("Start PSI Test suite")
                            .padding([.top, .bottom]).padding([.leading, .trailing])
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.headline)
                            .background(
                                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                    .fill(Color.orange)
                            )
                    }
                )
                .buttonStyle(PlainButtonStyle())

                Spacer()

                Button(
                    action: {
                        let testSuite = Array(
                            repeating: TestConfiguration.airDropOnlyTests,
                            count: Int(self.numberOfTests)!
                        ).flatMap({ $0 })

                        self.testController.runTests(testSuite: testSuite)
                        self.showSheet.toggle()
                    },
                    label: {
                        Text("Start AirDrop suite")
                            .padding([.top, .bottom]).padding([.leading, .trailing])
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                            .font(.headline)
                            .background(
                                RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                    .fill(Color.green)
                            )
                    }
                )
                .buttonStyle(PlainButtonStyle())

                Spacer()
            }

        }
    }
}

struct ReceiverTestView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverStartView()
            .frame(width: 480, height: 400)
            .environmentObject(TestController(role: .receiver))

    }
}
