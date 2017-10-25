//
//  ViewController.swift
//  MLDPtest-ios
//
//  Created by 江川主民 on 2017/10/25.
//  Copyright © 2017年 江川主民. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, UITextFieldDelegate {
    
    var isScanning = false
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral!
    var myservice: CBService!
    var settingCharacteristic: CBCharacteristic!
    var outputCharacteristic: CBCharacteristic!
    
    let target_peripheral_name = "EGABLE2D4D"
    //    let target_service_uuid = CBUUID(string: "C4CB6B0E-AF17-11E7-ABC4-CEC278B6B50A")
    let target_service_uuid = CBUUID(string: "00035B03-58E6-07DD-021A-08123A000300")
    //    let unknown_service_uuid = CBUUID(string: "C956F3CA-24EB-11E7-93AE-92361F002671")
    //    let target_charactaristic_uuid = CBUUID(string: "C4CB71BC-AF17-11E7-ABC4-CEC278B6B50A")
    //    let target_charactaristic_uuid2 = CBUUID(string: "C4CB72F2-AF17-11E7-ABC4-CEC278B6B50A")
    let target_charactaristic_uuid = CBUUID(string: "00035B03-58E6-07DD-021A-08123A000301")
    let target_charactaristic_uuid2 = CBUUID(string: "00035B03-58E6-07DD-021A-08123A0003FF")
    var response = ""
    
    //    @IBOutlet weak var scanBtn: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        textField.delegate = self
        
        centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    // MARK: CBCentralManagerDelegate
    
    // セントラルマネージャの状態が変化すると呼ばれる
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("state: \(central.state)")
        switch central.state {
        case .poweredOff:
            print("Bluetoothの電源がOff")
        case .poweredOn:
            print("Bluetoothの電源はOn")
        case .resetting:
            print("レスティング状態")
        case .unauthorized:
            print("非認証状態")
        case .unknown:
            print("不明")
        case .unsupported:
            print("非対応")
        }
    }
    
    // ペリフェラルを発見すると呼ばれる
    func centralManager(_ central: CBCentralManager,didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        self.peripheral = peripheral
        centralManager?.stopScan()
        
        //接続開始
        central.connect(peripheral, options: nil)
    }
    
    // ペリフェラルへの接続が成功すると呼ばれる
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("接続成功！")
        print("BLEデバイス: \(peripheral)")
        
        centralManager.stopScan()
        print("スキャン終了！")
        
        // サービス探索結果を受け取るためにデリゲートをセット
        self.peripheral.delegate = self
        
        // サービス探索開始
        //        self.peripheral.discoverServices(nil)
    }
    
    
    // MARK:CBPeripheralDelegate
    
    // サービス発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        guard let services = peripheral.services, services.count > 0 else {
            print("no services")
            return
        }
        print("\(services.count) 個のサービスを発見！ \(services)")
        
        for service in services {
            // キャラクタリスティックを探索開始
            self.peripheral.discoverCharacteristics(nil, for: service)
            //            self.peripheral.discoverCharacteristics([target_charactaristic_uuid, target_charactaristic_uuid2], for: service)
        }
    }
    
    // キャラクタリスティック発見時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        guard let characteristics = service.characteristics, characteristics.count > 0 else {
            print("no characteristics")
            return
        }
        print("\(characteristics.count) 個のキャラクタリスティックを発見！ \(characteristics)")
        
        //        for characteristic in characteristics where characteristic.uuid.isEqual(target_charactaristic_uuid) {
        //
        //            outputCharacteristic = characteristic
        //            print("Write Indicate UUID を発見！")
        //
        //            //            peripheral.readValueForCharacteristic(characteristic)
        //
        //            // 更新通知受け取りを開始する
        //            peripheral.setNotifyValue(true, for: characteristic)
        //        }
    }
    
    // Notify開始／停止時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didUpdateNotificationStateFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print(error.debugDescription)
        } else {
            print("Notify状態更新成功！characteristic UUID:\(characteristic.uuid), isNotifying: \(characteristic.isNotifying)")
        }
    }
    
    // データ更新時に呼ばれる
    func peripheral(_ peripheral: CBPeripheral,
                    didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
        
        if error != nil {
            print(error.debugDescription)
            return
        }
        
        //        updateWithData(data: characteristic.value!)
    }
    
    // データ書き込みが完了すると呼ばれる
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("書き込み失敗...error: \(error.debugDescription), characteristic uuid: \(characteristic.uuid)")
            return
        }
        
        //        print(NSString(data: characteristic.value!, encoding: NSUTF8StringEncoding))
        
        print("書き込み成功！service uuid: \(characteristic.service.uuid), characteristic uuid: \(characteristic.uuid)")
    }
    
    // =========================================================================
    // MARK: Actions
    
    @IBAction func scanBtnTapped(_ sender: UIButton) {
        //        if isScanning {
        //            centralManager.stopScan()
        //            isScanning = false
        //        } else {
        //            isScanning = true
        // BLEデバイスの検出を開始.
        centralManager.scanForPeripherals(withServices:[target_service_uuid], options: nil)
        //        }
    }
    
    @IBAction func sendBtnTapped(_ sender: UIButton) {
        // キーボードを閉じる
        textField.endEditing(true)
    }
    
    @IBAction func clearBtnTapped(_ sender: UIButton) {
    }
    
    
    func getData(){
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        
        return true
    }
}
