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

extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate{
    
    
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
        let properties: CBCharacteristicProperties = [.notify, .read, .write]
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
//    private func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?)
//    {
//        if let error = error {
//            print(“Failed… error: \(error)”)
//            return
//        }
//        print(“Succeeded!”)
//    }

    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.centralManager = CBCentralManager(delegate: self, queue: nil)
//        self.centralManager.delegate = self
//
//        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
//    }
//
//    override var representedObject: Any? {
//        didSet {
//        // Update the view, if already loaded.
//        }
//    }
    
    func logMsg(msg:String){
        txtChat.stringValue = txtChat.stringValue + msg + "\n"
    }
    
    
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let discoveredPeripheral = peripheral
        if(!self.allDiscPeripherals.contains(discoveredPeripheral)){
//            print("Found new CBPeripheral: " + (discoveredPeripheral.name != nil ? discoveredPeripheral.name! : "")) //prints found new CBPeripheral both for ios9 and ios 10
            print("peri: \(discoveredPeripheral)")
            self.allDiscPeripherals.append(discoveredPeripheral)
            discoveredPeripheral.delegate = self
//            if(discoveredPeripheral.name != nil && discoveredPeripheral.name! == "Daria"){
            if(discoveredPeripheral.identifier == UUID(uuidString: "77027073-6157-4C9B-9C64-93AE5FAF797F")){
//                discoveredPeripheral.identifier == "77027073-6157-4C9B-9C64-93AE5FAF797F"
                self.logMsg(msg: "Discovered peripheral \(discoveredPeripheral.identifier) => Trying to connect ...")
                var tmp = -1
                tmp /= -1
                self.centralManager.connect(discoveredPeripheral, options: nil)
            }
        }
        
//        centralManager.connect(discoveredPeripheral, options: nil)
    }
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
//        self.centralManager.retrievePeripherals(withIdentifiers: [UUID(string: "2456E1B9-26E2-8F83-E744-F34F01E9D701")])
        print("Peripheral did update name: " + peripheral.name!)
    }
    
//    private func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
//        let discoveredPeripheral = peripheral
//        print("found new CBPeripheral") //prints found new CBPeripheral both for ios9 and ios 10
//        centralManager.connect(discoveredPeripheral, options: nil)
//    }
    
//    private func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [NSObject : AnyObject], RSSI: NSNumber) {
//
//        var localName: String = advertisementData[CBAdvertisementDataLocalNameKey] as String
//
////        if (countElements(localName) > 0) {
////            print("Found Mac: \(localName)")
////            self.centralManager.stopScan()
////        } else {
//            print("Not Found")
////        }
//    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        var tmp = -1
        tmp /= -1
        guard let services = peripheral.services else { return }

        for service in services {
//          print(service)
            self.logMsg(msg: "> Discovered a service: \(service) => Trying to get characteristics ...")
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
        guard let characteristics = service.characteristics else { return }

        for characteristic in characteristics {
            self.logMsg(msg: "  > Discovered characteristics: \(characteristic) => AND NOW ??? ...")
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverIncludedServicesFor service: CBService, error: Error?) {
        var tmp = -1
        tmp /= -1
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected peripheral: " + peripheral.name!)
        self.logMsg(msg: "> Connected peripheral \(peripheral.identifier) => Discovering services ...")
//        let cafe: Data? = "Café".data(using: .utf8) // non-nil
//        peripheral.writeValue(cafe, for: CBDescriptor ))
        peripheral.discoverServices(nil)

    }
//    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
//        print("1")
//    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("Disconnected peripheral: " + peripheral.name!)
    }

//    private func centralManager(central: CBCentralManager!, didDisconnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
//        print("2")
//    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Did FAIL to connected peripheral: " + peripheral.name!)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            print("Powered Off")
        case .poweredOn:
            print("Powered On")
            self.centralManager.scanForPeripherals(withServices: nil, options: nil)// [CBCentralManagerScanOptionAllowDuplicatesKey: true])
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

    @IBAction func connect(_ sender: Any){
        self.centralManager.scanForPeripherals(withServices: nil, options: nil)
    }
}

