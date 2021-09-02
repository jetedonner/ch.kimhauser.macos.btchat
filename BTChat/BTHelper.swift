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
    case CHAR_LONG_UUID = "12689034-B356-463E-9F48-BAB068903123"
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
    
    func sendingBytes() {
        let maxLen:Int = (self.daPeripheral?.maximumWriteValueLength(for: .withResponse))!
        sendDataIndex = 0
        print("Maximum writeValue len: \(maxLen)")
//        self.dataToSend = NSData(data: txtMsg.stringValue.data(using: .utf8)!)
        while dataToSend.count > sendDataIndex {
            var amountToSend = dataToSend.count - sendDataIndex
            
            if amountToSend > maxLen {
                amountToSend = maxLen
            }

            let chunk = Data(bytes: UnsafeRawPointer(NSData(data: dataToSend).bytes + sendDataIndex), count: amountToSend)
            //adding to the header with chunk
//            let strData = String(format: "%dHello %@", CountValue, chunk as CVarArg)

            let ChunkHeaderAddded = chunk// strData.data(using: .utf8)

            print("\(String(describing: ChunkHeaderAddded))")
            CountValue = Int(CountValue) + 1
//            let boolValue = connectingPeripheral.canSendWriteWithoutResponse
//            if !boolValue {
//                EmptyReceiveImagedata.insert(ChunkHeaderAddded, at: 0)
//                //      return;
//            }
            self.daPeripheral!.writeValue(ChunkHeaderAddded, for: self.daCharLong!, type: .withResponse)
            sendDataIndex += amountToSend
        }
//        if completionFlag == false {
//            sendDataIndex = 0
//            print(String(format: "CountOf ---> %lu", UInt(EmptyReceiveImagedata.count)))
//            while EmptyReceiveImagedata.count > sendDataIndex {
//                print(String(format: "sendData ---> %ld", Int(sendDataIndex)))
//                //      Boolean boolValue = (self.ConnectingPeripheral.canSendWriteWithoutResponse);
//                //      if (!boolValue) {
//                //        return;
//                //      }
//                connectingPeripheral.writeValue(EmptyReceiveImagedata.object(atIndex: sendDataIndex), for: characterstics, type: .withoutResponse)
//                sendDataIndex = sendDataIndex + 1
//            }
//        }
//        let count: Float = Float((10 * sendDataIndex) / dataToSend.length)
//        completion = count / 10
//        BleDelegate.progressBarCallback(completion)
        
//        if let EOM_MSG = EOM_MSG {
        self.daPeripheral!.writeValue(EOM_MSG.data(using: .utf8)!, for: self.daCharLong!, type: .withResponse)
//        }
//        BleDelegate.connnectingStatus(false)
//        BleDelegate.didCompleteStatus()
        completionFlag = true
        self.daPeripheral!.setNotifyValue(true, for: self.daCharLong!)
        print("SentAll the packets")
//        notification("Sent all the packets")
//        completion = 0.0
    }
}

