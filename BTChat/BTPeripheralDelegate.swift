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

//enum Constants: String {
//    case SERVICE_UUID = "40689029-B356-463E-9F48-BAB068903EF5"
//    case CHAR_UUID = "40689029-B356-463E-9F48-BAB068903123"
//}

extension ViewController: CBPeripheralDelegate{
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        print("Peripheral did update name: " + peripheral.name!)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            self.logMsg(msg: "> Discovered a service: \(service) => Trying to get characteristics ...")
            peripheral.discoverCharacteristics([CBUUID(string: Constants.CHAR_UUID.rawValue)], for: service)
        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        
        self.cmbNearby.menu?.items.removeAll()
        self.cmbNearby.menu?.items.append(NSMenuItem(title: peripheral.name!, action: nil, keyEquivalent: "D"))
        
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            self.logMsg(msg: "  > Discovered characteristics: \(characteristic) => AND NOW ??? ...")
            if(characteristic.uuid.isEqual(CBUUID(string: "40689029-B356-463E-9F48-BAB068903123"))){
                self.daPeripheral = peripheral
                self.daChar = characteristic
                self.logMsg(msg: "  > Discovered RIGHT characteristics: \(characteristic) => Sending data ...")
                peripheral.writeValue("Sending hello BTChat !!!!".data(using: .utf8)!, for: characteristic, type: .withoutResponse)
                self.logStatus(status: "Sending data ...")
                break
//                self.peripheralManager.updateValue("Sending hello BTChat !!!!".data(using: .utf8)!, for: characteristic as! CBMutableCharacteristic, onSubscribedCentrals: nil)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
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
            print("Message sent=======>")//\(String(describing: characteristic.value))
        }else{

            print("Message Not sent=======>\(String(describing: error))")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        var tmp = -1
        tmp /= -1
    }
}

