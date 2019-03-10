//
//  ViewController.swift
//  IRS_GUI
//
//  Created by ding_qili on 2019/3/6.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        @IBOutlet weak var proFileComboBox: NSComboBox!
        @IBOutlet weak var profileComboBox: NSComboBox!
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

