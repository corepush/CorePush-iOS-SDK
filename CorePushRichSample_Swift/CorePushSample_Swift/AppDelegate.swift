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
        
        //    //アプリ内のユーザーIDの設定
        //    corePushManager.appUserId = "username"
        //
        //    //現在地の位置情報を送信する。
        //    corePushManager.locationServiceEnabled = true
        //    corePushManager.reportCurrentLocation()
        
        return true
    }
    
    // 通知サービスの登録成功時に呼ばれる。
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
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
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        //*********************************************************************************************
        // アイコンバッジ数をリセットする
        //*********************************************************************************************
        CorePushManager.resetApplicationIconBadgeNumber()
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let corePushManager = CorePushManager.shared() as! CorePushManager
        if corePushManager.pushEnabled {
            //フォアグランド起動時にデバイストークンを送信
            let defaults = UserDefaults.standard
            if let deviceToken = defaults.object(forKey: CorePushDeviceTokenKey) as? String, deviceToken != "" {
                corePushManager.registerDeviceTokenString(deviceToken)
            }
        }
    }

}

// MARK: - CorePushManagerDelegate

extension AppDelegate: CorePushManagerDelegate {
    
    func handleBackgroundNotification(_ userInfo: [AnyHashable: Any]) {
        
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
    
    func handleForegroundNotifcation(_ userInfo: [AnyHashable: Any]) {
        
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
    
    func handleLaunchingNotification(_ userInfo: [AnyHashable: Any]) {
        
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
    
    func addPassesViewControllerDidFinish(_ controller: PKAddPassesViewController) {
        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    func safariLaunch(_ button: UIButton) {
        let alert = UIAlertView(title: "確認", message: "safariを起動します。\nよろしいでしょうか。", delegate: self, cancelButtonTitle: "キャンセル", otherButtonTitles: "OK")
        alert.tag = 9
        alert.show()
    }
    
    func showPassbook() {
        if PKPassLibrary.isPassLibraryAvailable() {
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
                
                if let passbookUrl = self.passbookUrl {
                    let pkPassUrl = URL(string: passbookUrl)!
                    let urlRequest = NSMutableURLRequest(url: pkPassUrl)
                    urlRequest.httpMethod = "GET"
                    let userAgent = "iPhone OS 6"
                    urlRequest.setValue(userAgent, forKey: "User-Agent")
                    var error: NSError?
                    do {
                        let data = try NSURLConnection.sendSynchronousRequest(urlRequest as URLRequest, returning: nil)
                        
                        let pkPass = PKPass(data: data, error: &error)
                        
                        if error != nil {
                            let addCtrl = PKAddPassesViewController(pass: pkPass)
                            addCtrl.delegate = self
                            self.window?.rootViewController?.present(addCtrl, animated: true, completion: nil)
                        }
                        
                    } catch _ {
                        NSLog("connection error.")
                    }
                }
                
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                
            }
        }
        
    }
}

// MARK: - アラートのデリゲート

extension AppDelegate: UIAlertViewDelegate {
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if alertView.tag == 8 && buttonIndex == 1 {
            
            //PassbookのURLを表示
            showPassbook()
        } else if alertView.tag == 9 && buttonIndex == 1 {
            
            //Safariでリッチ通知のURLを表示
            if let richUrl = self.richUrl {
                UIApplication.shared.openURL(URL(string: richUrl)!)
                popupView?.hide()
            }
        }
    }
}

extension AppDelegate {
    
    //リッチ通知の画面を表示
    func showPopupView() {
        guard let window = UIApplication.shared.delegate?.window! else { return }
        
        guard let urlAddress = self.richUrl else {
            return
        }

        let popupView = CorePushPopupView(frame: CGRect(x: 0, y: 100, width: 300, height: 400), withParentView: window)
        self.popupView = popupView
        if let info = Bundle.main.infoDictionary, let appName = info["CFBundleDisplayName"] as? String {
            popupView?.titleBarText = "\(appName)からのお知らせ"
            popupView?.center = window.center
            popupView?.buildLayoutSubViews()
            
            let rect = CGRect(x: 0, y: 0,
                width: (popupView?.contentView.frame.size.width)!,
                height: (popupView?.contentView.frame.size.height)!)
            let webView = UIWebView(frame: rect)
         
            let url = URL(string: urlAddress)!
            let requestObj = URLRequest(url: url)
            webView.loadRequest(requestObj)
            webView.scalesPageToFit = true
            popupView?.contentView.addSubview(webView)
            
            let safariLaunchButton = UIButton(type: .custom)
            safariLaunchButton.frame = CGRect(x: 0, y: 0,
                width: (popupView?.contentView.frame.size.width)!,
                height: (popupView?.contentView.frame.size.height)!)
            
            safariLaunchButton.backgroundColor = UIColor.clear
            safariLaunchButton.addTarget(self, action: #selector(AppDelegate.safariLaunch(_:)), for: .touchUpInside)
          
            popupView?.contentView.addSubview(safariLaunchButton)
          
            popupView?.show()
        }
    }
}


