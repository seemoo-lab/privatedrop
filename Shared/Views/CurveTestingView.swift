//
//  CurveTestingView.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 12.01.21.
//  Copyright © 2021 SEEMOO - TU Darmstadt. All rights reserved.
//

import PSI
import Relic
import SwiftUI

struct CurveTestingView: View {

    @State var showAlert: Bool = false
    @State var alertText: Text?
    @State var alertTitle: Text = Text("Alert")

    var body: some View {
        VStack {
            Button("Exponentiations") {
                self.testExponentiationSpeed()
            }
        }.alert(
            isPresented: self.$showAlert,
            content: {
                Alert(title: self.alertTitle, message: self.alertText, dismissButton: .cancel())
            })
    }

    func testExponentiationSpeed() {
        PSI.initialize(config: .init(useECPointCompression: true))
        let numberOfExponentiations = 10_000

        // Generate random Big Numbers and random points on the curve for exponentiation
        var a = [bn_t]()
        var b = [ec_t]()

        var order = ECC.order
        for _ in 0..<numberOfExponentiations {
            a.append(BN.generateRandomInZq())

            var bn_b = BN.generateRandomInZq()
            var bn_mod = BN.newBN()
            bn_w_modulus(&bn_mod, &bn_b, &order)
            var curvePoint = ec_t()
            ec_multiply_gen(&curvePoint, &bn_mod)

            b.append(curvePoint)
        }

        // Measure time needed for exponentiation
        let startTime = Date()
        var exponentiations = [ec_t]()
        for i in 0..<numberOfExponentiations {
            let e = ECC.mulitply(ecPoint: b[i], number: a[i])
            exponentiations.append(e)
        }
        let endTime = Date()
        assert(exponentiations.count == numberOfExponentiations)

        let totalTime = endTime.timeIntervalSince(startTime)
        self.alertText = Text(
            "Calculating \(numberOfExponentiations) took \(totalTime)s\n \(totalTime/Double(numberOfExponentiations))s per exponentiation"
        )
        self.alertTitle = Text("Measurement finished")
        self.showAlert = true

    }
}

struct CurveTestingView_Previews: PreviewProvider {
    static var previews: some View {
        CurveTestingView()
    }
}
