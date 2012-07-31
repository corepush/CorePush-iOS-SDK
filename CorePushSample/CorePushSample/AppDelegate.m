//
//  AppDelegate.m
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import "AppDelegate.h"
#import <CorePush/CorePushConfig.h>
#import "ViewController.h"

//*********************************************************************************************
// 通知のコンフィグキーの設定
//*********************************************************************************************

#define CONFIG_KEY @"XXXXXXXXXXXXXXXXX"


@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

// アプリの起動時に呼ばれる。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //プッシュ通知のON•OFFを設定するビューコントローラを作成
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.viewController.delegate = self;
    self.window.rootViewController = self.viewController;
    
    // サーバのレスポンスデータを格納するオブジェクトを作成
    [self.window makeKeyAndVisible];
    
    
    //*********************************************************************************************
    // CorePushManagerクラスの初期化
    //*********************************************************************************************
    [[CorePushManager shared] setConfigKey:CONFIG_KEY];          //コンフィグキーの設定
    [[CorePushManager shared] setDebugEnabled:YES];               //デバッグログを有効化
    [[CorePushManager shared] setDelegate:self];                 //CorePushManagerDelegateの設定
    [[CorePushManager shared] registerForRemoteNotifications];   //通知の登録
    
    //*********************************************************************************************
    // アプリのプロセスが起動していない状態で通知からアプリを起動した時の処理を定義する。
    // launchOptionsに通知のUserInfoが存在する場合は、CorePushManagerDelegate#handleLaunchingNotificationを
    // 呼び出し、存在しない場合は何も行わない。
    //*********************************************************************************************
    [[CorePushManager shared] handleLaunchingNotificationWithOption:launchOptions];
    
    //*********************************************************************************************
    // アイコンバッジ数をリセットする
    //*********************************************************************************************
    [CorePushManager resetApplicationIconBadgeNumber];
    
    return YES;
}

// 通知サービスの登録成功時に呼ばれる。
- (void) application:(UIApplication*) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //*********************************************************************************************
    // APNSの通知登録の成功時に呼び出される。デバイストークンをcore-aspサーバに登録する。
    //*********************************************************************************************
    [[CorePushManager shared] registerDeviceToken:deviceToken];
}

// 通知サービスの登録失敗時に呼ばれる。
- (void) application:(UIApplication*) application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //*********************************************************************************************
    // APNSの通知登録の失敗時に呼び出される。
    // 通知サービスの登録に失敗する場合は、iPhoneシミュレータでアプリを実行しているかプッシュ通知が有効化されていない
    // プロビジョニングでビルドしたアプリを実行している可能性があります。
    //*********************************************************************************************
    NSLog(@"error: %@", [error description]);
}

// アプリが通知を受信した場合に呼ばれる。
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //*********************************************************************************************
    // アプリがフォアグランド・バックグランド状態で動作中に通知を受信した時の動作を定義する。
    // バックラウンド状態で通知を受信後に通知からアプリを起動した場合、
    // CorePushManagerDelegate#handleBackgroundNotificationが呼び出されます。
    // フォアグランド状態で通知を受信した場合、CorePushManagerDelegate#handleForegroundNotificationが呼び出されます。
    //*********************************************************************************************
    [[CorePushManager shared] handleRemoteNotification:userInfo];
    
    //*********************************************************************************************
    // アイコンバッジ数をリセットする
    //*********************************************************************************************
    [CorePushManager resetApplicationIconBadgeNumber];
}


- (void)handleBackgroundNotification:(NSDictionary*)userInfo {
    
    //*********************************************************************************************
    // アプリがバックグランドで動作中に通知からアプリを起動した時の動作を定義
    //*********************************************************************************************
    
}

- (void)handleForegroundNotifcation:(NSDictionary*)userInfo {
    
    //*********************************************************************************************
    // アプリがフォアグランドで動作中に通知を受信した時の動作を定義
    // userInfoオブジェクトから通知メッセージを取得
    // NSString* message = (NSString*) [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    //
    // //通知のアラートを明示的に表示(アラートのタイトルはplistに定義されたアプリ名を使用)
    // NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    // UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:appName
    //                                                    message:message delegate:self
    //                                          cancelButtonTitle:nil
    //                                          otherButtonTitles:@"OK", nil];
    // [alertView show];
    // [alertView release];
    //*********************************************************************************************
    
}

- (void)handleLaunchingNotification:(NSDictionary*)userInfo {
    
    //*********************************************************************************************
    // アプリが起動中でない状態で通知からアプリを起動した場合に呼び出される。
    // userInfoオブジェクトから通知メッセージを取得
    // NSString* message = (NSString*) [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    // NSLog(@"message: %@", message);
    //*********************************************************************************************
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //*********************************************************************************************
    // アイコンバッジ数をリセットする
    //*********************************************************************************************
    [CorePushManager resetApplicationIconBadgeNumber];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}


@end
