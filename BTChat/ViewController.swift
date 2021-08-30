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
    @IBOutlet var txtChat:NSTextField!
    @IBOutlet var txtMsg:NSTextField!
    @IBOutlet var cmdSend:NSButton!
    
    @IBOutlet weak var window: NSWindow!
    public var centralManager: CBCentralManager!
    public var peripheralManager:CBPeripheralManager!
    public var name: String?
    
    public var allDiscPeripherals:[CBPeripheral] = []
    
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

