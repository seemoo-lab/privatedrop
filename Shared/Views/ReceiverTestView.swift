//
//  ReceiverTestView.swift
//  OpenDrop App
//
//  Created by Alex - SEEMOO on 27.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import SwiftUI

struct ReceiverStartView: View {
    var body: some View {
        VStack {
            Spacer()

            Button(
                action: {

                },
                label: {
                    Text("Start Receiving")
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

struct ReceiverTestView_Previews: PreviewProvider {
    static var previews: some View {
        ReceiverStartView()
            .frame(width: 480, height: 400)
    }
}
