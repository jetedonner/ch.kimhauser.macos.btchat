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

extension ViewController: CBPeripheralDelegate{
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("Peripheral did update name: " + peripheral.name!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }
        for service in services {
            peripheral.discoverCharacteristics([CBUUID(string: Constants.CHAR_UUID.rawValue), CBUUID(string: Constants.CHAR_LONG_UUID.rawValue)], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        
        
        self.cmbNearby.menu?.items.append(NSMenuItem(title: peripheral.name!, action: nil, keyEquivalent: "D"))
        
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            if(characteristic.uuid.isEqual(CBUUID(string: Constants.CHAR_UUID.rawValue))){
                self.daPeripheral = peripheral
                self.daChar = characteristic
                peripheral.writeValue("Sending hello BTChat !!!!".data(using: .utf8)!, for: characteristic, type: .withResponse)
                self.logStatus(status: "Sending data ...")
            }else if(characteristic.uuid.isEqual(CBUUID(string: Constants.CHAR_LONG_UUID.rawValue))){
                self.daPeripheral = peripheral
                self.daCharLong = characteristic
                self.logStatus(status: "Sending data (LONG) ...")
                do{
                    self.dataToSend = try CryptoHelper.encrypt(str: "Initial-MSG")
                    self.sendingBytes()
                }catch{
                    print("ERROR: Encryption failed! (\(error)")
                    self.logMsg(msg: "ERROR: Encryption failed! (\(error)")
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        self.logStatus(status: "Data sent!", stopProgressIndicator: true)
        if let error = error{
            self.logMsg(msg: "> ERROR: cannot writeValue(..) for \(characteristic): \(error)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if let error = error{
            self.logMsg(msg: "> ERROR: cannot writeValue(..) for \(characteristic): \(error)")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        if error == nil {
            print("Message sent=======>")
        }else{

            print("Message Not sent=======>\(String(describing: error))")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor descriptor: CBDescriptor, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        var tmp = -1
        tmp /= -1
    }
    
    func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
        print("Peripheral services changed...")
        peripheral.discoverServices([CBUUID(string: Constants.SERVICE_UUID.rawValue)])
    }
}

