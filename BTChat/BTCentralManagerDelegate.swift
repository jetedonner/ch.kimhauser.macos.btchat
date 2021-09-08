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
import Defaults

extension ViewController: CBCentralManagerDelegate{
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let discoveredPeripheral = peripheral
        
        if((self.allDiscPeripherals[discoveredPeripheral.identifier.uuidString] == nil)){
            print("peri: \(discoveredPeripheral)")
            self.allDiscPeripherals[discoveredPeripheral.identifier.uuidString] = discoveredPeripheral
            discoveredPeripheral.delegate = self
            self.centralManager.connect(discoveredPeripheral, options: nil)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected peripheral: " + peripheral.name!)
        self.sqlLiteHelper?.insert(name: peripheral.name!, uuid: peripheral.identifier.uuidString, mac: peripheral.identifier.uuidString)
        
        if((self.allDiscPeripherals[peripheral.identifier.uuidString] == nil)){
            print("peri: \(peripheral)")
            self.allDiscPeripherals[peripheral.identifier.uuidString] = peripheral
            peripheral.delegate = self
//            self.centralManager.connect(discoveredPeripheral, options: nil)
            peripheral.discoverServices([CBUUID(string: Constants.SERVICE_UUID.rawValue)])
        }
        

    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected peripheral: " + peripheral.name!)
        
        self.allDiscPeripherals = self.allDiscPeripherals.filter { $0.value.identifier != peripheral.identifier }
        
//        if(self.allDiscPeripherals.contains(peripheral)){
//            self.allDiscPeripherals.removeAll(where: peripheral)
//        }
        if let error = error{
            print("ERROR: \(error)")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Did FAIL to connected peripheral: " + peripheral.name!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if(central.state == .poweredOn && Defaults[.autoStartScan]){
            self.tryScanForBTChat(central.state)
        }
    }
}

