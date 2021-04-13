//
//  SavePanel.swift
//  Read_FindMy_Keys
//
//  Created by Alex - SEEMOO on 08.06.20.
//  Copyright © 2020 SEEMOO - TU Darmstadt. All rights reserved.
//

import AppKit
import Foundation

class SavePanel: NSObject, NSOpenSavePanelDelegate {

    static let shared = SavePanel()

    var fileToSave: Data?
    var fileExtension: String?
    var panel: NSSavePanel?

    func saveFile(
        file: Data, fileExtension: String, nameFieldLabel: String = "", filename: String = "Export"
    ) {
        self.fileToSave = file
        self.fileExtension = fileExtension

        self.panel = NSSavePanel()
        self.panel?.delegate = self
        self.panel?.title = "Export"
        self.panel?.prompt = "Export"
        self.panel?.nameFieldLabel = nameFieldLabel
        self.panel?.nameFieldStringValue = filename + "." + fileExtension
        self.panel?.allowedFileTypes = [fileExtension]

        self.panel?.begin(completionHandler: { (result) in
            if result == NSApplication.ModalResponse.OK {
                // Save file
                let fileURL = self.panel?.url
                try? self.fileToSave?.write(to: fileURL!)
            }
        })

    }

    func panel(_ sender: Any, userEnteredFilename filename: String, confirmed okFlag: Bool)
        -> String?
    {
        guard okFlag else { return nil }

        return filename
    }

}
