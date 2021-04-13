//
//  SenderTestingView.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 28.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

struct SenderTestingView: View {
    @EnvironmentObject var testController: TestController
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            LoadingView(isAnimating: true)
                .padding()

            (Text("Current config")
                .bold()
                + Text("\nAddressbook size: \(self.testController.addressbookSizeString)")
                + Text(
                    ":\nIds: \(self.testController.privateDrop?.configuration.contacts.otherPrecomputedValues?.ids.count ?? 0)"
                ))
                .multilineTextAlignment(.leading)
                .frame(minHeight: 80)
                .padding()

            if self.testController.state == .precomputing {
                Text("Precomputing values")
                    .font(.headline)

                Text("Cannot send files yet")
            } else {
                Text(
                    "Performed \(self.testController.classicAirDropDone + self.testController.psiAirDropDone) of \(self.testController.numberOfTests*2)"
                )

                ProgressBar(value: self.$testController.progress)
                    .frame(height: 20)

                Text("State")
                    .font(.subheadline)
                    .padding(.top)

                if self.testController.state == .senderWaiting {
                    Text("Waiting")
                } else if self.testController.state == .sending {
                    Text("Sending")
                }
            }

            if self.testController.iterations?.count ?? 0 > 0 {
                Text("\(self.testController.iterations?.count ?? 0) iterations missing")
            }

            #if os(macOS)
                Spacer()
                    .frame(height: 50)
            #elseif os(iOS)
                Spacer()
            #endif

            Button(
                action: {
                    self.testController.stopTests()
                },
                label: {
                    Text("Cancel Tests")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                .fill(Color.red)
                        )

                }
            )
            .buttonStyle(PlainButtonStyle())
            .padding(.bottom)

        }
        .padding()
        .fixedSize(horizontal: true, vertical: true)
        .alert(
            isPresented: self.$testController.showError,
            content: { () -> Alert in
                Alert(
                    title: Text("An errror occurred"),
                    message: Text("\(String(describing:self.testController.error!))"),
                    dismissButton: .cancel())
            }
        )
        .onReceive(self.testController.$testIsRunning) { (testRunning) in
            if testRunning == false {
                #if os(macOS)
                    self.presentationMode.wrappedValue.dismiss()
                #endif
            }
        }
    }
}

struct SenderTestingView_Previews: PreviewProvider {
    @State static var error: Error?
    @State static var showError = false

    static var previews: some View {
        SenderTestingView()
            .frame(width: 480, height: 400)
            .environmentObject(TestController(role: .sender))
    }
}
