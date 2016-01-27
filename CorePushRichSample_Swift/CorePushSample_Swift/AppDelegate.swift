//
//  AppDelegate.swift
//  CorePushSample_Swift
//
//  Copyright © 2016年 株式会社ブレスサービス. All rights reserved.
//

import UIKit
import PassKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var richUrl: String?
    var passbookUrl: String?
    var popupView: CorePushPopupView?
    
    //*********************************************************************************************
    // 通知のコンフィグキーの設定
    //*********************************************************************************************
    
    // ※コンフィグキーの文字列の型にはNSString型を使用し、CorePushManagerのconfigKeyの設定時に
    // String型にキャストして使用してください。
    let CONFIG_KEY: NSString = "XXXXXXXXXXXXXXXXX"

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
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
        corePushManager.handleLaunchingNotificationWithOption(launchOptions)
        
        //*********************************************************************************************
        // アイコンバッジ数をリセットする
        //*********************************************************************************************
        CorePushManager.resetApplicationIconBadgeNumber()
        
        //    //アプリ内のユーザーIDの設定
        //    corePushManager.appUserId = "username"
        //
        //    //現在地の位置情報を送信する。
        //    corePushManager.locationServiceEnabled = true
        //    corePushManager.reportCurrentLocation()
        
        return true
    }
    
    // 通知サービスの登録成功時に呼ばれる。
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        //*********************************************************************************************
        // APNSの通知登録の成功時に呼び出される。デバイストークンをcore-aspサーバに登録する。
        //*********************************************************************************************
        
        //    let corePushManager = CorePushManager.shared() as! CorePushManager
        //    corePushManager.deviceIdEnabled = true
        //    corePushManager.deviceIdHashEnabled = true
        //    let categoryIds: NSMutableArray = ["0", "1", "2", "3", "4", "5"]
        //    corePushManager.categoryIds = categoryIds
        //    corePushManager.appUserId = "userid"
        let corePushManager = CorePushManager.shared() as! CorePushManager
        corePushManager.registerDeviceToken(deviceToken)
    }
    
    // 通知サービスの登録失敗時に呼ばれる。
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        
        //*********************************************************************************************
        // APNSの通知登録の失敗時に呼び出される。
        // 通知サービスの登録に失敗する場合は、iPhoneシミュレータでアプリを実行しているかプッシュ通知が有効化されていない
        // プロビジョニングでビルドしたアプリを実行している可能性があります。
        //*********************************************************************************************
        NSLog("error: \(error.description)")
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
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
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
        //    let corePushManager = CorePushManager.shared() as! CorePushManager
        //    corePushManager.deviceIdEnabled = true
        //    corePushManager.deviceIdHashEnabled = true
        //    let categoryIds: NSMutableArray = ["0", "1", "2", "3", "4", "5"]
        //    corePushManager.categoryIds = categoryIds
        //    corePushManager.appUserId = "userid"
        
        // iOS8以上で デバイストークン登録用の UIApplication#application:didRegisterForRemoteNotificationsWithDeviceToken メソッドが呼び出されるように
        // UIApplication#registerForRemoteNotification を明示的に呼びだしてください。
        application.registerForRemoteNotifications()
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        //*********************************************************************************************
        // アイコンバッジ数をリセットする
        //*********************************************************************************************
        CorePushManager.resetApplicationIconBadgeNumber()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }

    func applicationWillEnterForeground(application: UIApplication) {
        let corePushManager = CorePushManager.shared() as! CorePushManager
        if corePushManager.pushEnabled {
            //フォアグランド起動時にデバイストークンを送信
            let defaults = NSUserDefaults.standardUserDefaults()
            if let deviceToken = defaults.objectForKey(CorePushDeviceTokenKey) as? String where deviceToken != "" {
                corePushManager.registerDeviceTokenString(deviceToken)
            }
        }
    }

}

// MARK: - CorePushManagerDelegate

extension AppDelegate: CorePushManagerDelegate {
    
    func handleBackgroundNotification(userInfo: [NSObject : AnyObject]!) {
        
        //*********************************************************************************************
        //    //アプリがバックグランドで動作中に通知からアプリを起動した時の動作を定義
        //    if let url = userInfo["url"] as? String where url != "" {
        //        self.richUrl = url
        //        
        //        if let richUrl = self.richUrl where url.hasPrefix("pass://") {
        //
        //            //Passbookの画面を表示
        //            self.passbookUrl = richUrl.stringByReplacingOccurrencesOfString("pass://", withString: "http://")
        //            
        //            if let info = NSBundle.mainBundle().infoDictionary, let appName = info["CFBundleDisplayName"] as? String {
        //                
        //                let alert = UIAlertView(title: "\(appName)からのお知らせ",
        //                    message: "Passbookが届きました。\n表示しますか？",
        //                    delegate: self,
        //                    cancelButtonTitle:
        //                    "キャンセル",
        //                    otherButtonTitles: "表示")
        //                alert.tag = 8
        //                alert.show()
        //            }
        //        } else {
        //            // リッチ通知の画面を表示
        //            showPopupView()
        //        }
        //    }
        //*********************************************************************************************
        
        //*********************************************************************************************
        //  通知からの起動を把握するためのアクセス解析用のパラメータを送信
        //  if let pushId = userInfo["push_id"] as? String {
        //      let corePushManager = CorePushAnalyticsManager.shared() as! CorePushAnalyticsManager
        //      corePushManager.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
        //  }
        //*********************************************************************************************
    }
    
    func handleForegroundNotifcation(userInfo: [NSObject : AnyObject]!) {
        
        //*********************************************************************************************
        //    //アプリがフォアグランドで動作中に通知を受信した時の動作を定義
        //    if let url = userInfo["url"] as? String where url != "" {
        //        self.richUrl = url
        //
        //        if let richUrl = self.richUrl where url.hasPrefix("pass://") {
        //
        //            //Passbookの画面を表示
        //            self.passbookUrl = richUrl.stringByReplacingOccurrencesOfString("pass://", withString: "http://")
        //
        //            if let info = NSBundle.mainBundle().infoDictionary, let appName = info["CFBundleDisplayName"] as? String {
        //
        //                let alert = UIAlertView(title: "\(appName)からのお知らせ",
        //                    message: "Passbookが届きました。\n表示しますか？",
        //                    delegate: self,
        //                    cancelButtonTitle:
        //                    "キャンセル",
        //                    otherButtonTitles: "表示")
        //                alert.tag = 8
        //                alert.show()
        //            }
        //        } else {
        //            // リッチ通知の画面を表示
        //            showPopupView()
        //        }
        //        return
        //    }
        //
        //    // リッチ通知ではない場合 userInfoオブジェクトから通知メッセージを取得
        //    if let message = userInfo["aps"]?["alert"] as? String {
        //
        //       //通知のアラートを明示的に表示(アラートのタイトルはplistに定義されたアプリ名を使用)
        //       if let info = NSBundle.mainBundle().infoDictionary, let appName = info["CFBundleDisplayName"] as? String {
        //
        //           UIAlertView(title: appName,
        //               message: message,
        //               delegate: nil,
        //               cancelButtonTitle:
        //               nil,
        //               otherButtonTitles: "OK").show()
        //       }
        //     }
        //*********************************************************************************************
        
        //*********************************************************************************************
        //  通知からの起動を把握するためのアクセス解析用のパラメータを送信
        // if let pushId = userInfo["push_id"] as? String {
        //    let corePushManager = CorePushAnalyticsManager.shared() as! CorePushAnalyticsManager
        //    corePushManager.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
        // }
        //*******************************************************************************************s
    }
    
    func handleLaunchingNotification(userInfo: [NSObject : AnyObject]!) {
        
        //*********************************************************************************************
        //    //アプリが起動中でない状態で通知からアプリを起動した時の動作を定義
        //
        //    if let url = userInfo["url"] as? String where url != "" {
        //        self.richUrl = url
        //
        //        if let richUrl = self.richUrl where url.hasPrefix("pass://") {
        //
        //            //Passbookの画面を表示
        //            self.passbookUrl = richUrl.stringByReplacingOccurrencesOfString("pass://", withString: "http://")
        //
        //            if let info = NSBundle.mainBundle().infoDictionary, let appName = info["CFBundleDisplayName"] as? String {
        //
        //                let alert = UIAlertView(title: "\(appName)からのお知らせ",
        //                    message: "Passbookが届きました。\n表示しますか？",
        //                    delegate: self,
        //                    cancelButtonTitle:
        //                    "キャンセル",
        //                    otherButtonTitles: "表示")
        //                alert.tag = 8
        //                alert.show()
        //            }
        //        } else {
        //            // リッチ通知の画面を表示
        //            let delay = 0.1 * Double(NSEC_PER_SEC)
        //            let time  = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        //            dispatch_after(time, dispatch_get_main_queue(), {
        //                self.showPopupView()
        //            })
        //        }
        //        return
        //    }
        //
        //     
        //    //userInfoオブジェクトから通知メッセージを取得
        //    if let message = userInfo["aps"]?["alert"] as? String {
        //       NSLog("message: \(message)")
        //    }
        //********************************************************************************************
        
        //*********************************************************************************************
        //    //通知からの起動を把握するためのアクセス解析用のパラメータを送信
        //    if let pushId = userInfo["push_id"] as? String {
        //        let corePushManager = CorePushAnalyticsManager.shared() as! CorePushAnalyticsManager
        //        corePushManager.requestAppLaunchAnalytics(pushId, latitude: "0", longitude: "0")
        //    }
        //*********************************************************************************************
    }
}

// MARK: - Passbook

extension AppDelegate: PKAddPassesViewControllerDelegate {
    
    func addPassesViewControllerDidFinish(controller: PKAddPassesViewController) {
        self.window?.rootViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func safariLaunch(button: UIButton) {
        let alert = UIAlertView(title: "確認", message: "safariを起動します。\nよろしいでしょうか。", delegate: self, cancelButtonTitle: "キャンセル", otherButtonTitles: "OK")
        alert.tag = 9
        alert.show()
    }
    
    func showPassbook() {
       
        let version = Float(UIDevice.currentDevice().systemVersion)
        
        // OSのバージョンが6以上の場合、Passbookを表示
        if version >= 6.0 {
            if PKPassLibrary.isPassLibraryAvailable() {
             
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) {
                    
                    if let passbookUrl = self.passbookUrl {
                        let pkPassUrl = NSURL(string: passbookUrl)!
                        let urlRequest = NSMutableURLRequest(URL: pkPassUrl)
                        urlRequest.HTTPMethod = "GET"
                        let userAgent = "iPhone OS 6"
                        urlRequest.setValue(userAgent, forKey: "User-Agent")
                        var error: NSError?
                        do {
                            let data = try NSURLConnection.sendSynchronousRequest(urlRequest, returningResponse: nil)
                            
                            let pkPass = PKPass(data: data, error: &error)
                            
                            if error != nil {
                                let addCtrl = PKAddPassesViewController(pass: pkPass)
                                addCtrl.delegate = self
                                self.window?.rootViewController?.presentViewController(addCtrl, animated: true, completion: nil)
                            }
                            
                        } catch _ {
                            NSLog("connection error.")
                        }
                    }
                    
                    dispatch_async(dispatch_get_main_queue()) {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    }
     
                }
            } else {


            }
        } else {
            //OSのバージョンが6.0未満の場合の処理を記述
            if let passbookUrl = self.passbookUrl {
                UIApplication.sharedApplication().openURL(NSURL(string: passbookUrl)!)
            }
        }
    }
}

// MARK: - アラートのデリゲート

extension AppDelegate: UIAlertViewDelegate {
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if alertView.tag == 8 && buttonIndex == 1 {
            
            //PassbookのURLを表示
            showPassbook()
        } else if alertView.tag == 9 && buttonIndex == 1 {
            
            //Safariでリッチ通知のURLを表示
            if let richUrl = self.richUrl {
                UIApplication.sharedApplication().openURL(NSURL(string: richUrl)!)
                popupView?.hide()
            }
        }
    }
}

extension AppDelegate {
    
    //リッチ通知の画面を表示
    func showPopupView() {
        guard let window = UIApplication.sharedApplication().delegate?.window! else { return }
        
        guard let urlAddress = self.richUrl else {
            return
        }

        let popupView = CorePushPopupView(frame: CGRectMake(0, 100, 300, 400), withParentView: window)
        self.popupView = popupView
        if let info = NSBundle.mainBundle().infoDictionary, let appName = info["CFBundleDisplayName"] as? String {
            popupView.titleBarText = "\(appName)からのお知らせ"
            popupView.center = window.center
            popupView.buildLayoutSubViews()
            
            let rect = CGRectMake(0, 0,
                popupView.contentView.frame.size.width,
                popupView.contentView.frame.size.height)
            let webView = UIWebView(frame: rect)
         
            let url = NSURL(string: urlAddress)!
            let requestObj = NSURLRequest(URL: url)
            webView.loadRequest(requestObj)
            webView.scalesPageToFit = true
            popupView.contentView.addSubview(webView)
            
            let safariLaunchButton = UIButton(type: .Custom)
            safariLaunchButton.frame = CGRectMake(0, 0,
                popupView.contentView.frame.size.width,
                popupView.contentView.frame.size.height)
            
            safariLaunchButton.backgroundColor = UIColor.clearColor()
            safariLaunchButton.addTarget(self, action: "safariLaunch:", forControlEvents: .TouchUpInside)
          
            popupView.contentView.addSubview(safariLaunchButton)
          
            popupView.show()
        }
    }
}


