//
//  UIViewController+ Bluetooth.swift
//  Cup
//
//  Created by king on 15/11/17.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import CoreBluetooth

public protocol BluetoothDelegate : NSObjectProtocol{
    var serviceUUIDs: [CBUUID]? {get}
    func scanForPeripherals(_ central: CBCentralManager)
    func characteristicUUIDs(_ service: CBUUID) -> [CBUUID]?
    func didDiscoverPeripheral(_ peripheral: CBPeripheral)
    func didDiscoverCharacteristicsForService(_ characteristic: CBCharacteristic)
}
//extension BluetoothDelegate where Self: UIViewController, Self: CBPeripheralDelegate {
extension UIViewController: BluetoothDelegate,CBCentralManagerDelegate,CBPeripheralDelegate {
    open var serviceUUIDs: [CBUUID]? {
        get{
            return nil
        }
    }

    open func scanForPeripherals(_ central: CBCentralManager) {
        central.scanForPeripherals(withServices: nil, options: nil)
    }

    open func characteristicUUIDs(_ service: CBUUID) -> [CBUUID]? {
        return nil
    }
    open func didDiscoverPeripheral(_ peripheral: CBPeripheral) {

    }
    open func didDiscoverCharacteristicsForService(_ characteristic: CBCharacteristic) {

    }

    open func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state == .poweredOn {
            self.scanForPeripherals(central)
        }else if central.state == .poweredOn {
            let alertController = UIAlertController(title: nil, message: "打开蓝牙来允许本应用连接到配件", preferredStyle: .alert)
            self.present(alertController, animated: true, completion: nil)
            let prefsAction = UIAlertAction(title: "设置", style: .default, handler: {
                (action) -> Void in
                UIApplication.shared.openURL(URL(string: "prefs:root=Bluetooth")!)
            })
            let okAction = UIAlertAction(title: "好", style: UIAlertActionStyle.default) {
                (_) -> Void in
            }
            alertController.addAction(prefsAction)
            alertController.addAction(okAction)
        }else if central.state == .unsupported {
            self.ks.noticeOnlyText("抱歉你的设备不支持蓝牙。无法使用本应用")
        }

    }
    open func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        self.didDiscoverPeripheral(peripheral)
    }
    open func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        peripheral.delegate = self
        peripheral.discoverServices(serviceUUIDs)
    }
    open func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        if let error = error {
            print(error)
        }
    }

    open func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?)
    {
        if let services = peripheral.services {
            for service in services {
                service.peripheral.discoverCharacteristics(characteristicUUIDs(service.uuid), for: service)
            }
        }
    }
    open func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                self.didDiscoverCharacteristicsForService(characteristic)
            }
        }
    }
}

