//
//  MainView.swift
//  IRS_GUI
//
//  Created by ding_qili on 2019/3/6.
//  Copyright © 2019 ding_qili. All rights reserved.
//

import Cocoa

class MainView: NSView {

    var fileDropBlock:(URL) -> Void = {_ in }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
    }
    
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        guard let filePath = sender.draggingPasteboard.propertyList(forType: NSPasteboard.PasteboardType.fileURL) as? String , let fileUrl = URL(string: filePath) else{
            return false
        }
        guard dropFileTypes.contains(fileUrl.pathExtension) else {
            return false
        }
        #if DEBUG
            print(fileUrl)
        #endif
        fileDropBlock(fileUrl)
        return true
    }
    
}
