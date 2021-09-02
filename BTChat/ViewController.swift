//
//  ViewController.swift
//  StatusBar
//
//  Created by sycf_ios on 2017/12/14.
//  Copyright © 2017年 sycf_ios. All rights reserved.
//

import Cocoa
import CoreBluetooth
import Preferences

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
    var daCharLong:CBCharacteristic?
    
//    var dataToSend:NSData = NSData()
    var sendDataIndex:Int = 0
    var CountValue:Int = 0
    var completionFlag:Bool = false
    var dataToSend:NSData = NSData(data: "MULTI LINBE EXAMPLE".data(using: .utf8)!)
    let EOM_MSG = "###==BTChat-EOM==###".data(using: .utf8)
//    var dariaUUID:UUID = UUID(uuidString: "77027073-6157-4C9B-9C64-93AE5FAF797F")!
    
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
    
    private lazy var preferencesWindowController = PreferencesWindowController(
        preferencePanes: [
            GeneralPreferenceViewController(),
            AdvancedPreferenceViewController()
        ],
        style: .toolbarItems
    )

//    func applicationDidFinishLaunching(_ notification: Notification) {}

    @IBAction
    func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            // Do something against ENTER key
            var str = txtMsg.stringValue
            self.sendBTChatMsg(cmdSend)
            self.dataToSend =  NSData(data: str.data(using: .utf8)!)
            self.sendingBytes()
            return true
        }
        // return true if the action was handled; otherwise false
        return false
    }
    
    
    @IBAction func showAbout(_ sender:Any?){
        NSApp.activate(ignoringOtherApps: true)
        NSApp.orderFrontStandardAboutPanel(sender)
    }

}

