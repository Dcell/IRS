//
//  CustomInfoModule.swift
//  IRS_GUI
//
//  Created by ding_qili on 2019/3/10.
//  Copyright © 2019 ding_qili. All rights reserved.
//

import Cocoa

@objc
class CustomInfoModule: NSObject {
    static let customInfoModule = CustomInfoModule()
    private override init() {
        super.init()
    }
    
    @objc dynamic var AppIcon20x20_2x:String = ""
    @objc dynamic var AppIcon20x20_3x:String = ""
    @objc dynamic var AppIcon29x29_2x:String = ""
    @objc dynamic var AppIcon29x29_3x:String = ""
    @objc dynamic var AppIcon40x40_2x:String = ""
    @objc dynamic var AppIcon40x40_3x:String = ""
    @objc dynamic var AppIcon60x60_2x:String = ""
    @objc dynamic var AppIcon60x60_3x:String = ""
    
    @objc dynamic var LaunchImage_700_568h_2x:String = ""
    @objc dynamic var LaunchImage_700_2x:String = ""
    @objc dynamic var LaunchImage_800_667h_2x:String = ""
    @objc dynamic var LaunchImage_800_Portrait_736h_3x:String = ""
    @objc dynamic var LaunchImage_800_Landscape_736h:String = ""
    @objc dynamic var LaunchImage_1100_Portrait_2436h:String = ""
    
    
    @objc dynamic var CFBundleVersion:String = ""
    @objc dynamic var CFBundleShortVersionString:String = ""
    @objc dynamic var CFBundleDisplayName:String = ""
    
    @objc dynamic var Assets:String = ""
    
    var replaceFiles:[String]{
        var files:[String] = []
        let mirror = Mirror(reflecting: self)
        for case let (label?, value) in mirror.children {
            if label.hasPrefix("AppIcon") || label.hasPrefix("LaunchImage_") || label.hasPrefix("Assets"){
                if let  stringValue = value as? String , !stringValue.isEmpty{
                    files.append(stringValue)
                }
            }
        }
        return files
    }
    
    func clear(){
        let mirror = Mirror(reflecting: self)
        for case let (label?, _) in mirror.children {
            self.setValue("", forKey: label)
        }
    }
    
}
