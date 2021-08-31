//
//  BTHelper.swift
//  BTChat
//
//  Created by Kim David Hauser on 30.08.21.
//  Copyright © 2021 sycf_ios. All rights reserved.
//

import Foundation
import Cocoa
import CoreBluetooth

enum Constants: String {
    case SERVICE_UUID = "40689029-B356-463E-9F48-BAB068903EF5"
    case CHAR_UUID = "40689029-B356-463E-9F48-BAB068903123"
}

extension ViewController {
    
    

    func logStatus(status:String, stopProgressIndicator:Bool = false){
        lblStatus.stringValue = status
        if(stopProgressIndicator){
            self.spnScnanning.stopAnimation(nil)
        }else{
            self.spnScnanning.startAnimation(nil)
        }
        self.spnScnanning.isHidden = stopProgressIndicator
    }
    
    func logMsg(msg:String){
        txtChat.string.append(msg + "\n")
        txtChat.scrollRangeToVisible(NSMakeRange(txtChat.string.count, 0))
    }

    
    func stopScan() {
        self.centralManager.stopScan()
        self.logStatus(status: "Scan stopped")
    }
    
    func tryScanForBTChat(_ state: CBManagerState) {
        switch (state) {
        case .poweredOff:
            print("Powered Off")
        case .poweredOn:
            print("Powered On")
            self.scanForBTChatNearby()
        case .unauthorized:
            print("Unauthorized")
        case .unknown:
            print("Unknown")
        case .unsupported:
            print("Unsupported")
        default:
            print("Default")
        }
    }
    
    func scanForBTChatNearby() {
        self.logStatus(status: "Scanning for contacts ...")
        self.spnScnanning.startAnimation(nil)
        self.centralManager.scanForPeripherals(withServices: [CBUUID(string: Constants.SERVICE_UUID.rawValue)], options: nil)// [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }

    @IBAction func doScanForBTChatNearby(_ sender: Any){
        self.tryScanForBTChat(self.centralManager.state)
    }
    
    @IBAction func sendBTChatMsg(_ sender: Any){
        self.daPeripheral!.writeValue(txtMsg.stringValue.data(using: .utf8)!, for: self.daChar!, type: .withResponse)
        self.logStatus(status: "Sending data ...")
        txtMsg.stringValue = ""
    }
}

