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
import LaunchAtLogin
import SQLite3

class ViewController: NSViewController, NSTextFieldDelegate {

    @IBOutlet var txtLog:NSTextField!
    @IBOutlet var txtChat:NSTextView!
    @IBOutlet var txtMsg:NSTextField!
    @IBOutlet var lblStatus:NSTextField!
    @IBOutlet var cmdSend:NSButton!
    @IBOutlet var spnScnanning:NSProgressIndicator!
    @IBOutlet var spnSending:NSProgressIndicator!
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
    var dataToSend:Data = "MULTI LINBE EXAMPLE".data(using: .utf8)!
    var dataReceived:Data = Data("".data(using: .utf8)!)
    var completion:Float = 0.0
    
    let EOM_MSG = "###==BTChat-EOM==###"
//    var dariaUUID:UUID = UUID(uuidString: "77027073-6157-4C9B-9C64-93AE5FAF797F")!
    
    var sqlLiteHelper:SQLiteHelper?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.centralManager = CBCentralManager(delegate: self, queue: nil)
        self.centralManager.delegate = self

        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        self.txtMsg.delegate = self
        
        
        print(LaunchAtLogin.isEnabled)
        //=> false

        LaunchAtLogin.isEnabled = false

        print(LaunchAtLogin.isEnabled)
        
        self.sqlLiteHelper = SQLiteHelper()
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
            AdvancedPreferenceViewController(),
            CommunicationPreferenceViewController()
        ],
        style: .toolbarItems
    )

//    func applicationDidFinishLaunching(_ notification: Notification) {}

    @IBAction
    func preferencesMenuItemActionHandler(_ sender: NSMenuItem) {
        preferencesWindowController.show()
        let appDelegate = NSApp.delegate as! AppDelegate
        appDelegate.closePopover(nil)
    }
    
    func trySendMsg(){
        if(txtMsg.stringValue == "") { return }
        
        self.dataToSend = txtMsg.stringValue.data(using: .utf8)!
        
        do{
            self.dataToSend = try CryptoHelper.encrypt(str: txtMsg.stringValue)
        }catch{
            print("ERROR: Encryption failed! (\(error)")
            self.logMsg(msg: "ERROR: Encryption failed! (\(error)")
        }
        self.sendingBytes()
        txtMsg.stringValue = ""
    }
    
    @IBAction func doScanForBTChatNearby(_ sender: Any){
        self.tryScanForBTChat(self.centralManager.state)
    }
    
    @IBAction func sendBTChatMsg(_ sender: Any){
        self.trySendMsg()
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            self.trySendMsg()
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

