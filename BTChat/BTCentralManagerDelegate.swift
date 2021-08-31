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
//            if(discoveredPeripheral.identifier == self.dariaUUID){
////                self.logMsg(msg: "Discovered peripheral \(discoveredPeripheral.identifier) => Trying to connect ...")
////                self.stopScan()
//                self.centralManager.connect(discoveredPeripheral, options: nil)
//            }else{
//                self.logMsg(msg: "Discovered peripheral \(discoveredPeripheral.identifier) => Trying to connect ...")
//                self.stopScan()
                self.centralManager.connect(discoveredPeripheral, options: nil)
//            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected peripheral: " + peripheral.name!)
//        self.logMsg(msg: "> Connected peripheral \(peripheral.identifier) => Discovering services ...")
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
//        self.tryScanForBTChat(central.state)
    }
}

