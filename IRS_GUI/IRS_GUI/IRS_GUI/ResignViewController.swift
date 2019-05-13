//
//  ResignViewController.swift
//  IRS_GUI
//
//  Created by ding_qili on 2019/3/7.
//  Copyright © 2019 ding_qili. All rights reserved.
//

import Cocoa

class ResignViewController: NSViewController {
    var srcIpaPath:String = ""
    var cerName:String = ""
    var appIdentifier:String = ""
    var outPutFileName = ""
    var proFilePath:String = ""
    //Custom
    var CFBundleVersion:String = ""
    var CFBundleShortVersionString:String = ""
    var CFBundleDisplayName:String = ""
    var replaceFiles:[String] = []
    private var replaceFolder:String = ""
    
    @IBOutlet var textView: NSTextView!
    let process:Process = Process()
    override func viewDidLoad() {
        super.viewDidLoad()
        if replaceFiles.count > 0 {
            if let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first{
                var tmp = cacheDirectory.appendingPathComponent("\(Date().description)").path
                tmp = tmp.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                try! FileManager.default.createDirectory(atPath: tmp, withIntermediateDirectories: true, attributes: nil)
                replaceFiles.forEach { (filePath) in
                    let lastPathComponent = URL(fileURLWithPath: filePath).lastPathComponent
                    try! FileManager.default.copyItem(atPath: filePath, toPath: tmp + "/\(lastPathComponent)")
                }
                replaceFolder = tmp
            }
            print("replaceFolder:\(replaceFolder)")
        }
        
        
        DispatchQueue.global().async {
            let result = self.reCodeSign()
            DispatchQueue.main.async {
                if result{
                    self.view.window?.close()
                }else{
                    let alert = NSAlert()
                    alert.messageText = "签名失败，请查看日志"
                    alert.runModal()
                }
            }
        }
    }
    
    
    func reCodeSign() -> Bool{
        if let shPath =  Bundle.main.path(forResource: "resign", ofType: ".sh"){
            self.chmodx()
            var arguments:[String] = [shPath,srcIpaPath,cerName,
                                      "-v",
                                      "-p",proFilePath,
                                      "-b",appIdentifier
                                        ]
            if !CFBundleVersion.isEmpty {
                arguments.append(contentsOf: ["--bundle-version",CFBundleVersion])
            }
            if !CFBundleShortVersionString.isEmpty {
                arguments.append(contentsOf: ["--short-version",CFBundleShortVersionString])
            }
            if !CFBundleDisplayName.isEmpty {
                arguments.append(contentsOf: ["-d",CFBundleDisplayName])
            }
            if !replaceFolder.isEmpty {
                arguments.append(contentsOf: ["--replace-folderfiles",replaceFolder])
            }
            
            arguments.append(outPutFileName)
            let outPut = self.process.exe("/bin/bash", arguments: arguments) { (log) in
                DispatchQueue.main.async {
                    let textStorage = self.textView.textStorage!
                    let endRange = NSRange(location: textStorage.length, length: 0)
                    textStorage.replaceCharacters(in: endRange, with: log)
                    self.textView.scrollPageDown(nil)
                }
            }
            return outPut == 0
        }
        return false
    }
    
    func chmodx(){
        if let shPath =  Bundle.main.path(forResource: "resign", ofType: ".sh"){
            let arguments:[String] = ["chmod","+x",shPath]
            let process:Process = Process()
            process.exe("/bin/bash", arguments: arguments)
        }
    }
    
    override func viewWillDisappear() {
        super.viewWillDisappear()
        self.process.interrupt()
    }
    
}
