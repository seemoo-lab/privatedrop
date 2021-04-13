//
//  SwiftUIActivityController.swift
//  PrivateDrop App
//
//  Created by Alex - SEEMOO on 30.07.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

struct SwiftUIActivityController: UIViewControllerRepresentable {

    /// Provide URLs to files that should be exported
    let activityItems: [Any]
    let completion: UIActivityViewController.CompletionWithItemsHandler?

    init(
        with activityItems: [Any], completion: UIActivityViewController.CompletionWithItemsHandler?
    ) {
        self.activityItems = activityItems
        self.completion = completion
    }

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityController = UIActivityViewController(
            activityItems: self.activityItems, applicationActivities: nil)

        activityController.completionWithItemsHandler = self.completion

        return activityController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {

    }
}
