//
//  ProgressBar.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 28.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import SwiftUI

struct ProgressBar: View {
    @Binding var value: Float

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color.gray)

                Rectangle().frame(
                    width: min(CGFloat(self.value) * geometry.size.width, geometry.size.width),
                    height: geometry.size.height
                )
                .foregroundColor(Color.blue)
                .animation(.linear)
            }.cornerRadius(45.0)
        }
    }

}
struct ProgressBar_Previews: PreviewProvider {
    @State static var progress: Float = 0.3
    static var previews: some View {
        ProgressBar(value: $progress)
    }
}
