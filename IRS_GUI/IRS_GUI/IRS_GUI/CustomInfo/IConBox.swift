//
//  IConBox.swift
//  IRS_GUI
//
//  Created by ding_qili on 2019/3/7.
//  Copyright © 2019 ding_qili. All rights reserved.
//

import Cocoa

class IConBox: NSBox {
    
    var dropFileBlock:(URL) -> Void = { _ in }
    
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.registerForDraggedTypes([NSPasteboard.PasteboardType.URL,NSPasteboard.PasteboardType.fileURL])
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        return .copy
    }
    
    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        sender.draggingPasteboard.pasteboardItems?.forEach({ (item) in
            guard let filePath = item.propertyList(forType: NSPasteboard.PasteboardType.fileURL) as? String , let fileUrl = URL(string: filePath) else{
                return
            }
            guard fileUrl.pathExtension == "png" else {
                return
            }
            dropFileBlock(fileUrl)
        })
        return true
    }
    
}
