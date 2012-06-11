//
//  AppDelegate.m
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#define CONFIG_KEY @"9b8cdedbfa669cf03c31c4f1807ddcce"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize receivedData = receivedData_;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [receivedData_ release];
    [super dealloc];
}

// アプリの起動時に呼ばれる。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //バッジアイコンの数値をリセット
    application.applicationIconBadgeNumber = 0;
    
    //プッシュ通知のON•OFFを設定するビューコントローラを作成
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.viewController.delegate = self;
    self.window.rootViewController = self.viewController;
    
    // サーバのレスポンスデータを格納するオブジェクトを作成
    self.receivedData = [NSMutableData data];
    
    
    //通知サービスの登録
    //アラート、バッジ、サウンドの通知を有効化。
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                           UIRemoteNotificationTypeBadge |
                                                                           UIRemoteNotificationTypeSound) ];
    
    [self.window makeKeyAndVisible];
    return YES;
}

// 通知サービスの登録成功時に呼ばれる。
- (void) application:(UIApplication*) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //デバイストークンの文字列を取得
    NSString* deviceTokenString = [NSString stringWithFormat:@"%@", deviceToken];
    deviceTokenString = [[deviceTokenString substringWithRange:NSMakeRange(1, [deviceTokenString length] - 2)] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"deviceTokenString: %@", deviceTokenString);
    
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:deviceTokenString forKey:@"DEVICE_TOKEN_STRING"];
    [defaults synchronize];
    
    
    //デバイストークンをサーバに送信する。
    [self sendDeviceTokenToServer:deviceTokenString];
}

// 通知サービスの登録失敗時に呼ばれる。
- (void) application:(UIApplication*) application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"didFailToRegisterForRemoteNotificationsWithError");
    self.viewController.notificationSwtich.on = NO;
    
}

// デバイストークンをサーバに送信する。
// deviceToken: デバイストークン
- (void)sendDeviceTokenToServer:(NSString*)deviceToken {
    
    // POSTデータの作成
    NSMutableDictionary* dict;
    dict = [NSMutableDictionary dictionary];
    [dict setObject:CONFIG_KEY forKey:@"config_key"]; // config_key パラメータ(必須)。設定キー 
    [dict setObject:deviceToken forKey:@"device_token"]; // device_token パラメータ(必須)。デバイストークン 
    //[dict setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"device_id"]; // device_id パラメータ。UDID(初期値: 1)
    //[dict setObject:@"1" forKey:@"category_id"]; // category_id パラメータ。カテゴリID。1桁の整数の配列(初期値:1)
    [dict setObject:@"1" forKey:@"mode"]; // mode パラメータ(必須)。デバイストークン(登録の場合:1 削除の場合:2) 
    [dict setObject:@"1" forKey:@"type"]; // type パラメータ(必須)。OSの種類(iPhoneの場合:1 Androidの場合:2)
    
    NSData* data;
    data = [self createPostDate:dict];
    
    // デバイストークンを指定のサーバに送信する。
    NSURL* url = [NSURL URLWithString:@"http://api.core-asp.com/iphone_token_regist.php"];
    NSMutableURLRequest* req;
    req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:data];
    
    [NSURLConnection connectionWithRequest:req delegate:self];
}

// デバイストークンをサーバから削除する。
- (void)removeDeviceTokenToServer:(NSString*)deviceToken  {
    // POSTデータの作成
    NSMutableDictionary* dict;
    dict = [NSMutableDictionary dictionary];
    [dict setObject:CONFIG_KEY forKey:@"config_key"]; // config_key パラメータ(必須)。設定キー 
    [dict setObject:deviceToken forKey:@"device_token"]; // device_token パラメータ(必須)。デバイストークン 
    //[dict setObject:[[UIDevice currentDevice] uniqueIdentifier] forKey:@"device_id"]; // device_id パラメータ。UDID(初期値: 1)
    //[dict setObject:@"1" forKey:@"category_id"]; // category_id パラメータ。カテゴリID。1桁の整数の配列(初期値:1)
    [dict setObject:@"2" forKey:@"mode"]; // mode パラメータ(必須)。デバイストークン(登録の場合:1 削除の場合:2) 
    [dict setObject:@"1" forKey:@"type"]; // type パラメータ(必須)。OSの種類(iPhoneの場合:1 Androidの場合:2)
    
    NSData* data;
    data = [self createPostDate:dict];
    
    // デバイストークンを指定のサーバに送信する。
    NSURL* url = [NSURL URLWithString:@"http://core-asp.com/push/api/device_regist.php"];
    NSMutableURLRequest* req;
    req = [NSMutableURLRequest requestWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:data];
    
    [NSURLConnection connectionWithRequest:req delegate:self];
}


//デバイストークンのサーバ送信が完了した場合に呼ばれる
- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    NSLog(@"connectionDidFinishLoading");
    
    NSString* responseString = [[NSString alloc] initWithData:receivedData_ encoding:NSUTF8StringEncoding];
    NSLog(@"responseString: %@", responseString);
    
    
    //レスポンスのstatusが0の場合は成功、1の場合は失敗。
}

// レスポンス受信時に呼ばれる
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
   [receivedData_ setLength:0];
}

// データ受信時に呼ばれる。
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData_ appendData:data];
}

//デバイストークンのサーバ送信が失敗した場合に呼ばれる
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", [error description]);
}

// POSTデータの作成
- (NSData*) createPostDate:(NSDictionary *)dict {
    
    NSMutableString* str;
    str = [NSMutableString stringWithCapacity:0];
    
    // POSTデータのkeyとvalueを作成
    for (NSString* key in [dict allKeys]) {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        NSString* value = [dict objectForKey:key];
        
        key = [key stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        value = [value stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        if ([str length] > 0) {
            [str appendString:@"&"];
        }
        
        [str appendFormat:@"%@=%@", key, value];
        [pool drain];
    }
    
    //UTF-8でエンコード
    NSData* data;
    data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return data;
}

// アプリが通知を受信した場合に呼ばれる。
- (void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //バッジアイコンの数値をリセット
    application.applicationIconBadgeNumber = 0;
    
    if (![application respondsToSelector:@selector(applicationState)] ||  application.applicationState == UIApplicationStateActive) {
        //フォアグランド時に通知を受信した場合
        NSLog(@"applicationState: foreground");
        
        // userInfoオブジェクトから通知メッセージを取得
        NSString* message = (NSString*) [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
        NSLog(@"message: %@", message);
        
        // 通知のアラートを明示的に表示
        // バックグランドで通知を受信した場合は自動的に通知のアラートが表示される。
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"CorePushSample"
                                                            message:message delegate:self
                                                  cancelButtonTitle:@"キャンセル"
                                                  otherButtonTitles:@"表示", nil];
        [alertView show];
        [alertView release];
        
    } else if (![application respondsToSelector:@selector(applicationState)] || application.applicationState == UIApplicationStateInactive) {
        //バックグランド時に通知を受信した場合
        NSLog(@"applicationState: background");
    }
}

// アプリをフォアグランドで起動した時に呼ばれる。
- (void)applicationWillEnterForeground:(UIApplication *)application {
    //バッジアイコンの数値をリセット
    application.applicationIconBadgeNumber = 0;
}


@end
