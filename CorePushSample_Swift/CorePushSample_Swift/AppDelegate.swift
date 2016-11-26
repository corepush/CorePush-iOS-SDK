//
//  AppDelegate.swift
//  CorePushSample_Swift
//
//  Copyright © 2015年 株式会社ブレスサービス. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    //*********************************************************************************************
    // 通知のコンフィグキーの設定
    //*********************************************************************************************
    
    // ※コンフィグキーの文字列の型にはNSString型を使用し、CorePushManagerのconfigKeyの設定時に
    // String型にキャストして使用してください。
    let CONFIG_KEY: NSString = "XXXXXXXXXXXXXXXXX"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //*********************************************************************************************
        // CorePushManagerクラスの初期化
        //*********************************************************************************************
        
        let corePushManager = CorePushManager.shared() as! CorePushManager
        corePushManager.configKey = CONFIG_KEY as String   // コンフィグキーの設定。String型にキャストして使用してください。
        corePushManager.debugEnabled = true                // デバッグログを有効
        corePushManager.delegate = self                    // CorePushManagerDelegateの設定
        corePushManager.registerForRemoteNotifications()   // 通知の登録
        
        //*********************************************************************************************
        // アプリのプロセスが起動していない状態で通知からアプリを起動した時の処理を定義する。
        // launchOptionsに通知のUserInfoが存在する場合は、CorePushManagerDelegate#handleLaunchingNotificationを
        // 呼び出し、存在しない場合は何も行わない。
        //*********************************************************************************************
        corePushManager.handleLaunchingNotification(withOption: launchOptions!)
        
        //*********************************************************************************************
        // アイコンバッジ数をリセットする
        //*********************************************************************************************
        CorePushManager.resetApplicationIconBadgeNumber()
        
        return true
    }
    
    // 通知サービスの登録成功時に呼ばれる。
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        //*********************************************************************************************
        // APNSの通知登録の成功時に呼び出される。デバイストークンをcore-aspサーバに登録する。
        //*********************************************************************************************
        let corePushManager = CorePushManager.shared() as! CorePushManager
        corePushManager.registerDeviceToken(deviceToken)
    }
    
    // 通知サービスの登録失敗時に呼ばれる。
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        //*********************************************************************************************
        // APNSの通知登録の失敗時に呼び出される。
        // 通知サービスの登録に失敗する場合は、iPhoneシミュレータでアプリを実行しているかプッシュ通知が有効化されていない
        // プロビジョニングでビルドしたアプリを実行している可能性があります。
        //*********************************************************************************************
        NSLog("error: \((error as NSError).description)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        //*********************************************************************************************
        // アプリがフォアグランド・バックグランド状態で動作中に通知を受信した時の動作を定義する。
        // バックラウンド状態で通知を受信後に通知からアプリを起動した場合、
        // CorePushManagerDelegate#handleBackgroundNotificationが呼び出されます。
        // フォアグランド状態で通知を受信した場合、CorePushManagerDelegate#handleForegroundNotificationが呼び出されます。
        //*********************************************************************************************
        let corePushManager = CorePushManager.shared() as! CorePushManager
        corePushManager.handleRemoteNotification(userInfo)
        
        //*********************************************************************************************
        // アイコンバッジ数をリセットする
        //*********************************************************************************************
        CorePushManager.resetApplicationIconBadgeNumber()
    }
    
    // iOS8以上の場合に呼び出される。
    @available(iOS 8.0, *)
    func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
        
        // iOS8以上で デバイストークン登録用の UIApplication#application:didRegisterForRemoteNotificationsWithDeviceToken メソッドが呼び出されるように
        // UIApplication#registerForRemoteNotification を明示的に呼びだしてください。
        application.registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //*********************************************************************************************
        // アイコンバッジ数をリセットする
        //*********************************************************************************************
        CorePushManager.resetApplicationIconBadgeNumber()
    }
    
}

// MARK: - CorePushManagerDelegate

extension AppDelegate: CorePushManagerDelegate {
    
    func handleBackgroundNotification(_ userInfo: [AnyHashable: Any]) {
        
        //*********************************************************************************************
        // アプリがバックグランドで動作中に通知からアプリを起動した時の動作を定義
        //*********************************************************************************************
        
        //*********************************************************************************************
        //  通知からの起動を把握するためのアクセス解析用のパラメータを送信
        //  if let pushId = userInfo["push_id"] as? String {
        //      let corePushManager = CorePushAnalyticsManager.shared() as! CorePushAnalyticsManager
        //      corePushManager.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
        //  }
        //*********************************************************************************************
    }
    
    func handleForegroundNotifcation(_ userInfo: [AnyHashable: Any]) {
        
        //*********************************************************************************************
        // アプリがフォアグランドで動作中に通知を受信した時の動作を定義
        // userInfoオブジェクトから通知メッセージを取得
        // if let message = userInfo["aps"]?["alert"] as? String {
        //
        //    if let info = NSBundle.mainBundle().infoDictionary, let appName = info["CFBundleDisplayName"] as? String {
        //
        //        UIAlertView(title: appName,
        //            message: message,
        //            delegate: nil,
        //            cancelButtonTitle:
        //            nil,
        //            otherButtonTitles: "OK").show()
        //    }
        //}
        //*********************************************************************************************
        
        //*********************************************************************************************
        //  通知からの起動を把握するためのアクセス解析用のパラメータを送信
        // if let pushId = userInfo["push_id"] as? String {
        //    let corePushManager = CorePushAnalyticsManager.shared() as! CorePushAnalyticsManager
        //    corePushManager.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
        // }
        //*******************************************************************************************s
    }
    
    func handleLaunchingNotification(_ userInfo: [AnyHashable: Any]) {
        
        //*********************************************************************************************
        // アプリが起動中でない状態で通知からアプリを起動した場合に呼び出される。
        // userInfoオブジェクトから通知メッセージを取得
        // if let message = userInfo["aps"]?["alert"] as? String {
        //    NSLog("message: \(message)")
        // }
        //********************************************************************************************
        
        //*********************************************************************************************
        //  通知からの起動を把握するためのアクセス解析用のパラメータを送信
        // if let pushId = userInfo["push_id"] as? String {
        //     let corePushManager = CorePushAnalyticsManager.shared() as! CorePushAnalyticsManager
        //     corePushManager.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
        // }
        //*********************************************************************************************
    }
}


