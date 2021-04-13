//
//  PSITestView .swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 31.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

struct PSITestView: View {
    @EnvironmentObject var psiTest: PSITestController
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            LoadingView(isAnimating: true)
                .padding()

            Text("Performed \(self.psiTest.testDone) of \(self.psiTest.numberOfTests)")

            ProgressBar(value: self.$psiTest.progress)
                .frame(height: 20)
            Spacer()

        }
        .padding()
        .onReceive(self.psiTest.$testIsRunning) { (testRunning) in
            if testRunning == false {
                #if os(macOS)
                    self.presentationMode.wrappedValue.dismiss()
                #endif
            }
        }
    }
}

struct PSITestView__Previews: PreviewProvider {
    static var previews: some View {
        PSITestView()
            .environmentObject(PSITestController())
    }
}
