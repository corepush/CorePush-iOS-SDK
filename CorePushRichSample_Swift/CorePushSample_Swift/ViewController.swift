//
//  ViewController.swift
//  CorePushSample_Swift
//
//  Copyright © 2016年 株式会社ブレスサービス. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "設定";
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //*********************************************************************************************
        // デバイストークの登録・削除時の通知をNotificationCenterに登録する。
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "registerTokenRequestSuccess", name: CorePushManagerRegisterTokenRequestSuccessNotification, object: nil)
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "registerTokenRequestFail", name: CorePushManagerRegisterTokenRequestFailNotification, object: nil)
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "unregisterTokenRequestSuccess", name: CorePushManagerUnregisterTokenRequestSuccessNotification, object: nil)
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "unregisterTokenRequestFail", name: CorePushManagerUnregisterTokenRequestFailNotification, object: nil)
        //*********************************************************************************************
        
        let corePushManager = CorePushManager.shared() as! CorePushManager
        if corePushManager.pushEnabled.boolValue {
            notificationSwitch.on = true
        } else {
            notificationSwitch.on = false
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
     
        //*********************************************************************************************
        // NotificationCenterからデバイストークの登録・削除時の通知を解除する。
        // NSNotificationCenter.defaultCenter().removeObserver(self, name: CorePushManagerRegisterTokenRequestSuccessNotification, object: nil)
        // NSNotificationCenter.defaultCenter().removeObserver(self, name: CorePushManagerRegisterTokenRequestFailNotification, object: nil)
        // NSNotificationCenter.defaultCenter().removeObserver(self, name: CorePushManagerUnregisterTokenRequestSuccessNotification, object: nil)
        // NSNotificationCenter.defaultCenter().removeObserver(self, name: CorePushManagerUnregisterTokenRequestFailNotification, object: nil)
        //*********************************************************************************************
    }
    
    @IBAction func valueChangeNotificationSwitch() {
        let corePushManager = CorePushManager.shared() as! CorePushManager
        
        if notificationSwitch.on {
            
            //*********************************************************************************************
            // プッシュ通知の有効化フラグをYESに設定
            //*********************************************************************************************
            corePushManager.pushEnabled = true
            
            //*********************************************************************************************
            // 通知の登録・デバイストークンをcore-aspサーバに登録
            //*********************************************************************************************
            corePushManager.registerForRemoteNotifications()
        } else {
            //*********************************************************************************************
            // プッシュ通知の有効化フラグをNOに設定
            //*********************************************************************************************
            corePushManager.pushEnabled = false
            
            //*********************************************************************************************
            // デバイストークンをcore-aspサーバから削除
            //*********************************************************************************************
            corePushManager.unregisterDeviceToken()
        }
    }
    
//*********************************************************************************************
//    // デバイストークン登録成功時に呼び出される。
//    func registerTokenRequestSuccess() {
//        notificationSwitch.on = true
//
//        UIAlertView(title: "成功", message: "デバイストークンの登録に成功",
//            delegate: nil,
//            cancelButtonTitle:
//            nil,
//            otherButtonTitles: "OK").show()
//    }
//    
//    
//    // デバイストークン登録失敗に呼び出される。
//    func registerTokenRequestFail() {
//        notificationSwitch.on = false
//        
//        UIAlertView(title: "エラー", message: "デバイストークンの登録に失敗",
//            delegate: nil,
//            cancelButtonTitle:
//            nil,
//            otherButtonTitles: "OK").show()
//    }
//
//    // デバイストークン削除成功時に呼び出される。
//    func unregisterTokenRequestSuccess() {
//        notificationSwitch.on = false
//        
//        UIAlertView(title: "成功", message: "デバイストークンの削除に成功",
//        delegate: nil,
//        cancelButtonTitle:
//        nil,
//        otherButtonTitles: "OK").show()
//    }
//    
//    // デバイストークン削除失敗時に呼び出される。
//    func unregisterTokenRequestFail() {
//        notificationSwitch.on = true
//        UIAlertView(title: "エラー", message: "デバイストークンの削除に失敗",
//            delegate: nil,
//            cancelButtonTitle: nil,
//            otherButtonTitles: "OK").show()
//    }
//*********************************************************************************************
}


