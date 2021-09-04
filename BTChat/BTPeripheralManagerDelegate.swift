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
import AppKit
import Defaults

extension ViewController: CBPeripheralManagerDelegate{

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            if peripheral.isAdvertising {
                peripheral.stopAdvertising()
            }

            let uuid = CBUUID(string: Constants.SERVICE_UUID.rawValue)
            var advertisingData: [String : Any] = [
                CBAdvertisementDataServiceUUIDsKey: [uuid]
            ]

            if let name = self.name {
                advertisingData[CBAdvertisementDataLocalNameKey] = name
            }
            self.peripheralManager?.startAdvertising(advertisingData)
        }else if peripheral.state == .poweredOff {
            self.logStatus(status: "BLE powered OFF!", stopProgressIndicator: true)
        }else if peripheral.state == .unauthorized {
            self.logStatus(status: "BLE unauthorized!", stopProgressIndicator: true)
        }else if peripheral.state == .unknown {
            self.logStatus(status: "BLE unknown!", stopProgressIndicator: true)
        }else if peripheral.state == .unsupported {
            self.logStatus(status: "BLE unsupported!", stopProgressIndicator: true)
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Failed ... error: \(error)")
            return
        }
        let serviceUUID = CBUUID(string: Constants.SERVICE_UUID.rawValue)
        let service = CBMutableService(type: serviceUUID, primary: true)
        
        let characteristicUUID = CBUUID(string: Constants.CHAR_UUID.rawValue)
        let properties: CBCharacteristicProperties = [.notify, .read, .write, .writeWithoutResponse]
        let permissions: CBAttributePermissions = [.readable, .writeable]
        let characteristic = CBMutableCharacteristic(
            type: characteristicUUID,
            properties: properties,
            value: nil,
            permissions: permissions)
        
        let characteristicLongUUID = CBUUID(string: Constants.CHAR_LONG_UUID.rawValue)
        let characteristicLong = CBMutableCharacteristic(
            type: characteristicLongUUID,
            properties: properties,
            value: nil,
            permissions: permissions)
        
        service.characteristics = [characteristic, characteristicLong]
        peripheralManager.add(service)
    }
    
    
    
    func peripheralManager(peripheral: CBPeripheralManager, didAddService service: CBService, error: NSError?)
    {
        if let error = error {
            print("error: \(error)")
            return
        }

        print("service: \(service)")
    }
    
    
    func peripheralManager(_ peripheral: CBPeripheralManager, didReceiveWrite requests: [CBATTRequest]) {
        if(requests.count == 1){
            let str:String = String(decoding: requests[0].value!, as: UTF8.self)
            if(requests[0].characteristic.uuid == self.daCharLong?.uuid){
                if(str == EOM_MSG){
                    
//                    do{
                        let tmpStr:String = CryptoHelper.decrypt(self.dataReceived.bytes)
//                        self.dataReceived = try CryptoHelper.aesDecrypt(encryptedData: self.dataReceived)
//                        let str:String = String(decoding: self.dataReceived, as: UTF8.self)
                        self.printNewMsg2Chat(msg: tmpStr)
                        if(Defaults[.playSoundIncoming]){
                            __NSBeep()
                        }
                        if(Defaults[.openBTIncoming]){
                            let appDelegate = NSApp.delegate as! AppDelegate
                            appDelegate.startPopover(nil)
                        }
//                    }catch {
//                        print("ERROR: Decryption failed!")
//                    }
                    
                    self.dataReceived.removeAll()
                }else{
                    self.dataReceived.append(requests[0].value!)
                }
            }else{
                self.printNewMsg2Chat(msg: str)
                if(Defaults[.playSoundIncoming]){
                    __NSBeep()
                }
                if(Defaults[.openBTIncoming]){
                    let appDelegate = NSApp.delegate as! AppDelegate
                    appDelegate.startPopover(nil)
                }
            }
            peripheral.respond(to: requests[0], withResult: .success)
        }
    }
    
    func printNewMsg2Chat(msg:String){
        var prefix:String = ""
        if(Defaults[.addTime2Chat]){
            let today = Date()
            let formatter3 = DateFormatter()
            formatter3.dateFormat = "HH:mm:ss"
            prefix = formatter3.string(from: today) + ": "
        }
        self.logMsg(msg: "\(prefix)\(msg)")
    }
}

