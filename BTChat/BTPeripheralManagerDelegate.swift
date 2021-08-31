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

extension ViewController: CBPeripheralManagerDelegate{
    
     
    // Some txt for git
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            if peripheral.isAdvertising {
                peripheral.stopAdvertising()
            }

            let uuid = CBUUID(string: Constants.SERVICE_UUID.rawValue)
            var advertisingData: [String : Any] = [
                CBAdvertisementDataServiceUUIDsKey: [uuid],
                CBAdvertisementDataIsConnectable: true
            ]
            

            if let name = self.name {
                advertisingData[CBAdvertisementDataLocalNameKey] = name
            }
            self.peripheralManager?.startAdvertising(advertisingData)
        } else {
//            #warning("handle other states")
        }
    }
    
    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("Failed… error: \(error)")
            return
        }
        print("Succeeded!")
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
        
        service.characteristics = [characteristic]
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
}

