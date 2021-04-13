//
//  PSIStartView.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 31.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

struct PSIStartView: View {
    @EnvironmentObject var psiTest: PSITestController

    @State var showSheet = false

    var body: some View {
        VStack {
            HStack {
                Text("Number of tests")
                    .bold()
                Spacer()
            }

            Stepper(
                onIncrement: {
                    if var numberOfTests = Int(self.psiTest.numberOfTestsString) {
                        numberOfTests += 1
                        self.psiTest.numberOfTestsString = "\(numberOfTests)"
                    }

                },
                onDecrement: {
                    if var numberOfTests = Int(self.psiTest.numberOfTestsString) {
                        numberOfTests -= 1
                        self.psiTest.numberOfTestsString = "\(numberOfTests)"
                    }
                },
                label: {
                    TextField("", text: self.$psiTest.numberOfTestsString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                })

            HStack {
                Text("Addressbook size")
                    .bold()
                Spacer()
            }

            Stepper(
                onIncrement: {
                    if var bookSize = Int(self.psiTest.addressbookSizeString) {
                        bookSize += 1
                        self.psiTest.addressbookSizeString = "\(bookSize)"
                    }

                },
                onDecrement: {
                    if var bookSize = Int(self.psiTest.addressbookSizeString) {
                        bookSize += 1
                        self.psiTest.addressbookSizeString = "\(bookSize)"
                    }
                },
                label: {
                    TextField("", text: self.$psiTest.addressbookSizeString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                })

            HStack {
                Text("Number of ids")
                    .bold()
                Spacer()
            }
            Stepper(
                onIncrement: {
                    let numberOfIds = self.psiTest.numberOfIds + 1
                    self.psiTest.numberOfIdsString = String(numberOfIds)
                },
                onDecrement: {
                    let numberOfIds = self.psiTest.numberOfIds - 1
                    self.psiTest.numberOfIdsString = String(numberOfIds)
                },
                label: {
                    TextField("", text: self.$psiTest.numberOfIdsString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                })

            Spacer()

            Button(
                action: {

                    self.psiTest.startTests()
                    self.showSheet.toggle()

                },
                label: {
                    Text("Start Tests")
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                .fill(Color.green)
                        )
                }
            )
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)
        }
        .sheet(isPresented: self.$showSheet) {
            if self.psiTest.exportedFileURL == nil {
                PSITestView()
                    .environmentObject(self.psiTest)
            } else {
                #if os(iOS)
                    SwiftUIActivityController(with: [self.psiTest.exportedFileURL!]) {
                        (_, _, _, _) in
                        try? FileManager.default.removeItem(at: self.psiTest.exportedFileURL!)
                        self.psiTest.exportedFileURL = nil
                        self.showSheet = false
                    }
                #endif
            }
        }

    }
}

struct PSIStartView_Previews: PreviewProvider {
    static var previews: some View {
        PSIStartView()
            .frame(width: 480, height: 400)
            .environmentObject(PSITestController())
    }
}
