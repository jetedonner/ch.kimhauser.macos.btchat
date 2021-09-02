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

extension ViewController: CBCentralManagerDelegate{
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let discoveredPeripheral = peripheral
        if(!self.allDiscPeripherals.contains(discoveredPeripheral)){
            print("peri: \(discoveredPeripheral)")
            self.allDiscPeripherals.append(discoveredPeripheral)
            discoveredPeripheral.delegate = self
            self.centralManager.connect(discoveredPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected peripheral: " + peripheral.name!)
        peripheral.discoverServices([CBUUID(string: Constants.SERVICE_UUID.rawValue)])

    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected peripheral: " + peripheral.name!)
        if let error = error{
            print("ERROR: \(error)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Did FAIL to connected peripheral: " + peripheral.name!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {

    }
}

