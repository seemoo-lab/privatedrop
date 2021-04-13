//
//  ReceiverTestingView.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 28.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

struct ReceiverTestingView: View {
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

                Text("Cannot receive any files yet")
            } else {
                Text("Original AirDrop")
                    .font(.headline)
                Text("Completed \(self.testController.classicAirDropDone) tests")
                    .padding(.bottom)

                Text("PSI AirDrop")
                    .font(.headline)
                Text("Completed \(self.testController.psiAirDropDone) tests")
                    .padding(.bottom)

                Text("State")
                    .font(.subheadline)
                    .padding(.top)

                if self.testController.state == .serverSetup {
                    Text("Server setup")
                } else if self.testController.state == .receiving {
                    Text("Receiving")
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

            Text("Press the finish button, when the sender has completed the tests")
                .padding(.bottom)

            Button(
                action: {
                    self.testController.stopTests()
                },
                label: {
                    Text("Stop tests")
                        .bold()
                        .foregroundColor(Color.white)
                        .padding([.top, .bottom])
                        .padding([.leading, .trailing], 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10.0, style: .continuous)
                                .fill(Color.blue)
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

struct ReceiverTestingView_Previews: PreviewProvider {

    static var previews: some View {
        ReceiverTestingView()
            .frame(width: 480, height: 400)
            .environmentObject(TestController(role: .receiver))
    }
}
