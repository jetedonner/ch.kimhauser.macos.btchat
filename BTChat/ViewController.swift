//
//  ViewController.swift
//  StatusBar
//
//  Created by sycf_ios on 2017/12/14.
//  Copyright © 2017年 sycf_ios. All rights reserved.
//

import Cocoa
import CoreBluetooth

class ViewController: NSViewController, NSTextFieldDelegate {

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
        
        self.txtMsg.delegate = self
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
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            print("enter")
            self.sendBTChatMsg(cmdSend)
            return true
        } else if (commandSelector == #selector(NSResponder.deleteForward(_:))) {
            // Do something against DELETE key
            return true
        } else if (commandSelector == #selector(NSResponder.deleteBackward(_:))) {
            // Do something against BACKSPACE key
            return true
        } else if (commandSelector == #selector(NSResponder.insertTab(_:))) {
            // Do something against TAB key
            return true
        } else if (commandSelector == #selector(NSResponder.cancelOperation(_:))) {
            // Do something against ESCAPE key
            return true
        }
        
        // return true if the action was handled; otherwise false
        return false
    }

}

