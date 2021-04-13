//
//  SenderTestView.swift
//  OpenDrop App
//
//  Created by Alex - SEEMOO on 27.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

struct SenderStartView: View {
    @State var fileSize: Float = 10.0
    @State var numberOfTests: String = "100"

    @State var addressBookSize: String = "1000"
    @EnvironmentObject var testController: TestController

    var body: some View {
        VStack {
            HStack {
                Text("File size")
                    .bold()
                Spacer()
            }

            HStack {
                Slider(value: $fileSize, in: 0.5...150.0)
                Text(String(format: "%.1f", self.fileSize))
            }

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

                })

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

                })

            Spacer()

            Button(
                action: {

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

    }
}

struct SenderTestView_Previews: PreviewProvider {
    static var previews: some View {
        SenderStartView()
            .frame(width: 480, height: 400)
            .environmentObject(TestController(role: .sender))
    }
}
