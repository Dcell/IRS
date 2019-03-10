//
//  CustomViewController.swift
//  IRS_GUI
//
//  Created by ding_qili on 2019/3/7.
//  Copyright © 2019 ding_qili. All rights reserved.
//

import Cocoa

class CustomViewController: NSViewController {

    @objc dynamic var customInfoModule:CustomInfoModule = CustomInfoModule.customInfoModule
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        self.view.subviews.forEach { (box) in
            if let iconBox = box as? IConBox{
                iconBox.dropFileBlock = { fileUrl in
                    if fileUrl.lastPathComponent == "AppIcon20x20@2x.png"{
                        self.customInfoModule.AppIcon20x20_2x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "AppIcon20x20@3x.png"{
                        self.customInfoModule.AppIcon20x20_3x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "AppIcon29x29@2x.png"{
                        self.customInfoModule.AppIcon29x29_2x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "AppIcon29x29@3x.png"{
                        self.customInfoModule.AppIcon29x29_3x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "AppIcon40x40@2x.png"{
                        self.customInfoModule.AppIcon40x40_2x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "AppIcon40x40@3x.png"{
                        self.customInfoModule.AppIcon40x40_3x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "AppIcon60x60@2x.png"{
                        self.customInfoModule.AppIcon60x60_2x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "AppIcon60x60@3x.png"{
                        self.customInfoModule.AppIcon60x60_3x = fileUrl.path
                    }
                }
            }else if let launchImageBox = box as? LaunchImageBox{
                launchImageBox.dropFileBlock = { fileUrl in
                    if fileUrl.lastPathComponent == "LaunchImage-700-568h@2x.png"{
                        self.customInfoModule.LaunchImage_700_568h_2x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "LaunchImage-700@2x.png"{
                        self.customInfoModule.LaunchImage_700_2x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "LaunchImage-800-667h@2x.png"{
                        self.customInfoModule.LaunchImage_800_667h_2x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "LaunchImage-800-Portrait-736h@3x.png"{
                        self.customInfoModule.LaunchImage_800_Portrait_736h_3x = fileUrl.path
                    }else if fileUrl.lastPathComponent == "LaunchImage-800-Landscape-736h@3x.png"{
                        self.customInfoModule.LaunchImage_800_Landscape_736h = fileUrl.path
                    }else if fileUrl.lastPathComponent == "LaunchImage-1100-Portrait-2436h@3x.png"{
                        self.customInfoModule.LaunchImage_1100_Portrait_2436h = fileUrl.path
                    }
                }
            }else if let launchImageBox = box as? AssetsBox{
                launchImageBox.dropFileBlock = { fileUrl in
                    self.customInfoModule.Assets = fileUrl.path
                }
            }
        }
    }
    
    @IBAction func clear(_ sender: Any) {
        customInfoModule.clear()
    }
    
}
