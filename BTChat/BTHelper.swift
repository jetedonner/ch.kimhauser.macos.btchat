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
import CryptoSwift

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
        txtChat.isEditable = true
        txtChat.checkTextInDocument(nil)
        txtChat.isEditable = false
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
        self.cmbNearby.menu?.items.removeAll()
        self.logStatus(status: "Scanning for contacts ...")
        self.spnScnanning.startAnimation(nil)
        self.centralManager.scanForPeripherals(withServices: [CBUUID(string: Constants.SERVICE_UUID.rawValue)], options: nil)// [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
    
    func sendingBytes() {
        
        guard let daPeripheral = self.daPeripheral else {
            return
        }
        
        let maxLen:Int = (daPeripheral.maximumWriteValueLength(for: .withResponse))
        sendDataIndex = 0
        completion = 0
        print("Maximum writeValue len: \(maxLen)")
        
        // Calculate Message Authentication Code (MAC) for message
//        let key: Array<UInt8> = [1,2,3,4,5,6,7,8,9,10,11,12,13,14]
//
//        do{
//            print("Poly1305: \(try Poly1305(key: key).authenticate(dataToSend.bytes))")
//            print("HMAC: \(try HMAC(key: key, variant: .sha256).authenticate(dataToSend.bytes))")
//            print("CMAC: \(try CMAC(key: key).authenticate(dataToSend.bytes))")
//        }catch{
//
//        }
        
        
//        let dataToSendLen = String(dataToSend.count)
//        let chunk = Data(bytes: UnsafeRawPointer(NSData(data: dataToSendLen.data(using: .utf8)!).bytes), count: dataToSendLen.count)
//        daPeripheral.writeValue(chunk, for: self.daCharLong!, type: .withResponse)
        
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
            daPeripheral.writeValue(ChunkHeaderAddded, for: self.daCharLong!, type: .withResponse)
            sendDataIndex += amountToSend
//            let count: Float = Float((10 * sendDataIndex) / dataToSend.count)
            completion = 100.0 / Float((dataToSend.count / sendDataIndex)) // count / 10
            DispatchQueue.main.async {
                self.spnSending.doubleValue = Double(self.completion)
                self.spnSending.updateLayer()
            }
            
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
        
//        BleDelegate.progressBarCallback(completion)
        
//        if let EOM_MSG = EOM_MSG {
        daPeripheral.writeValue(EOM_MSG.data(using: .utf8)!, for: self.daCharLong!, type: .withResponse)
//        }
//        BleDelegate.connnectingStatus(false)
//        BleDelegate.didCompleteStatus()
        completionFlag = true
        daPeripheral.setNotifyValue(true, for: self.daCharLong!)
        print("SentAll the packets")
//        notification("Sent all the packets")
//        completion = 0.0
    }
}

