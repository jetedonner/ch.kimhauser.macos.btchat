//
//  ViewController.swift
//  StatusBar
//
//  Created by sycf_ios on 2017/12/14.
//  Copyright © 2017年 sycf_ios. All rights reserved.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController {

    @IBOutlet var txtLog:NSTextField!
    @IBOutlet var txtChat:NSTextView!
    @IBOutlet var txtMsg:NSTextField!
    @IBOutlet var lblStatus:NSTextField!
    @IBOutlet var cmdSend:NSButton!
    @IBOutlet var spnScnanning:NSProgressIndicator!
    @IBOutlet var cmbNearby:NSPopUpButton!
    
    @IBOutlet weak var window: NSWindow!
    public var centralManager: CBCentralManager!
    public var peripheralManager:CBPeripheralManager!
    public var name: String?
    
    public var allDiscPeripherals:[CBPeripheral] = []
    var daPeripheral:CBPeripheral?
    var daChar:CBCharacteristic?
    
    var dariaUUID:UUID = UUID(uuidString: "77027073-6157-4C9B-9C64-93AE5FAF797F")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.centralManager.delegate = self

        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func close(_ sender: Any) {
        NSApp.terminate(sender)
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

