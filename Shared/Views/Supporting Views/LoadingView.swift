//
//  LoadingView.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 28.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import SwiftUI

#if os(macOS)
    import AppKit

    struct LoadingView: NSViewRepresentable {

        var isAnimating: Bool

        func makeNSView(context: Context) -> NSProgressIndicator {
            let progressIndicator = NSProgressIndicator()
            progressIndicator.controlSize = .regular
            progressIndicator.style = .spinning
            progressIndicator.isIndeterminate = true
            progressIndicator.isDisplayedWhenStopped = false

            return progressIndicator
        }

        func updateNSView(_ progressView: NSProgressIndicator, context: Context) {
            if isAnimating {
                progressView.startAnimation(nil)
            } else {
                progressView.stopAnimation(nil)
            }
        }
    }

#elseif os(iOS)
    import UIKit

    struct LoadingView: UIViewRepresentable {

        var isAnimating: Bool

        func makeUIView(context: Context) -> UIActivityIndicatorView {
            let activity = UIActivityIndicatorView(style: .large)
            activity.hidesWhenStopped = true
            return activity
        }

        func updateUIView(_ activity: UIActivityIndicatorView, context: Context) {
            if isAnimating && !activity.isAnimating {
                activity.startAnimating()
            } else if !isAnimating {
                activity.stopAnimating()
            }
        }
    }

#endif
