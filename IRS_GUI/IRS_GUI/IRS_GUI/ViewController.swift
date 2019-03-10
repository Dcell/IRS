//
//  ViewController.swift
//  IRS_GUI
//
//  Created by ding_qili on 2019/3/6.
//  Copyright © 2019 ding_qili. All rights reserved.
//

import Cocoa
import IRSSecurity

let dropFileTypes: [String] = ["ipa","mobileprovision"]
class ViewController: NSViewController {
    @objc dynamic var reSignName:String = ""
    @objc dynamic var reSignAppIdentifier:String = ""
    @objc dynamic var srcIpaPath:String = ""
    @objc dynamic var cerList:[String] = []
     @objc dynamic var cerListIndex:Int = 0
    @objc dynamic var proFileList:[IRSProfileClass] = []
    @objc dynamic var proFileIndex:Int = 0{
        didSet{
            self.reSignAppIdentifier = proFileList[proFileIndex].clearAppIdentifier
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.cerList = try! getCodesigningIdentity()
        self.proFileList = try! getInstalledProfiles().map({ (iRSProfile) -> IRSProfileClass in
            return iRSProfile.converToClass()
        })
        proFileIndex = 0
        // Do any additional setup after loading the view.
        
        if let mainView = self.view as? MainView{
            mainView.registerForDraggedTypes([NSPasteboard.PasteboardType.fileURL])
            mainView.fileDropBlock = { url in
                self.dropFile(fileurl: url)
            }
        }
    }

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if let resignViewController = segue.destinationController as? ResignViewController{
            resignViewController.appIdentifier = reSignAppIdentifier
            resignViewController.cerName = cerList[cerListIndex]
            resignViewController.srcIpaPath = srcIpaPath
            resignViewController.proFilePath = proFileList[proFileIndex].localPath.path
            resignViewController.outPutFileName = reSignName
            
            resignViewController.replaceFiles = CustomInfoModule.customInfoModule.replaceFiles
            resignViewController.CFBundleVersion = CustomInfoModule.customInfoModule.CFBundleVersion
            resignViewController.CFBundleShortVersionString = CustomInfoModule.customInfoModule.CFBundleShortVersionString
            resignViewController.CFBundleDisplayName = CustomInfoModule.customInfoModule.CFBundleDisplayName
        }
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    func dropFile(fileurl:URL){
        if fileurl.pathExtension == "mobileprovision" {
            do{
                let iRSProfile = try IRSProfile(fileurl)
                proFileList.append(iRSProfile.converToClass())
                proFileIndex = proFileList.count - 1
            }catch{}
        }else if fileurl.pathExtension == "ipa" {
            srcIpaPath = fileurl.path
            reSignName = fileurl.path.replacingOccurrences(of: fileurl.lastPathComponent, with: "resign_" + fileurl.lastPathComponent)
        }
    }
}

extension IRSProfile{
    func converToClass() -> IRSProfileClass{
        let iRSProfileClass =  IRSProfileClass(localPath: self.localPath, appIdentifier: self.appIdentifier, name: self.name)
        iRSProfileClass.expiretionDate = self.expiretionDate
        iRSProfileClass.creationDate = self.creationDate
        iRSProfileClass.teamIdentifier = self.teamIdentifier
        iRSProfileClass.teamName = self.teamName
        return iRSProfileClass
    }
    
}

class IRSProfileClass:NSObject{
    let localPath:URL
    
    let appIdentifier:String
    let name:String
    var expiretionDate:Date?
    var creationDate:Date?
    var teamIdentifier:[String]?
    var teamName:String?
    
    var clearAppIdentifier:String{
        guard let teamIdentifiers = self.teamIdentifier , teamIdentifiers.count > 0 else {
            return self.appIdentifier
        }
        guard let teamIdentifier = teamIdentifiers.first else {
            return self.appIdentifier
        }
        guard let range = self.appIdentifier.range(of: "\(teamIdentifier).") else{
            return self.appIdentifier
        }
        var appIdentifierCopy = self.appIdentifier
        appIdentifierCopy.removeSubrange(range)
        return appIdentifierCopy
    }
    
    init(localPath:URL,appIdentifier:String,name:String) {
        self.localPath = localPath
        self.appIdentifier = appIdentifier
        self.name = name
    }
    
    override var description: String{
        return self.name + "(\(appIdentifier))" + "(\(clearAppIdentifier))"
    }
    
    override var debugDescription: String{
        return self.description
    }
}

