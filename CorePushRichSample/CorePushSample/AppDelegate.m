//
//  AppDelegate.m
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NotificationHistoryViewController.h"
#import <CorePush/CorePushPopupView.h>
#import <CorePush/CorePushConfig.h>


//*********************************************************************************************
// 通知のコンフィグキーの設定
//*********************************************************************************************

#define CONFIG_KEY @"XXXXXXXXXXXXXXXXXXXXXXXXXXXX"


@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize richUrl = _richUrl;
@synthesize passbookUrl = _passbookUrl;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

// アプリの起動時に呼ばれる。
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //プッシュ通知のON•OFFを設定するビューコントローラを作成
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    ViewController* view1Ctrl = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    view1Ctrl.delegate = self;
    
    //通知履歴画面のビューコントローラを作成
    NotificationHistoryViewController* view2Ctrl = [[[NotificationHistoryViewController alloc] initWithNibName:@"NotificationHistoryViewController" bundle:nil] autorelease];
    
    //タブバーコントローラを作成
    UINavigationController* nav1Ctrl = [[UINavigationController alloc] initWithRootViewController:view1Ctrl];
    UINavigationController* nav2Ctrl = [[UINavigationController alloc] initWithRootViewController:view2Ctrl];
    self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    NSArray* viewControllers = [NSArray arrayWithObjects:nav1Ctrl,nav2Ctrl,nil];
    [self.tabBarController setViewControllers:viewControllers];
    
    self.window.rootViewController = self.tabBarController;
    
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
    
    //    //アプリ内のユーザーIDの設定
    //    [[CorePushManager shared] setAppUserId:@"username"];
    //
    //    //現在地の位置情報を送信する。
    //    [[CorePushManager shared] setLocationServiceEnabled:YES];
    //    [[CorePushManager shared] reportCurrentLocation];
    
    return YES;
}

// 通知サービスの登録成功時に呼ばれる。
- (void) application:(UIApplication*) application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //*********************************************************************************************
    // APNSの通知登録の成功時に呼び出される。デバイストークンをcore-aspサーバに登録する。
    //*********************************************************************************************

    //    [[CorePushManager shared] setDeviceIdEnabled:YES];
    //    [[CorePushManager shared] setDeviceIdHashEnabled:YES];
    ////    NSMutableArray* categoryids = [NSMutableArray arrayWithObjects:@"0",@"1", @"2", @"3", @"4", @"5", nil];
    //    [[CorePushManager shared] setCategoryIds:categoryids];
    //    [[CorePushManager shared] setAppUserId:@"userid"];
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
    //    //アプリがバックグランドで動作中に通知からアプリを起動した時の動作を定義
    //
    //    // userInfoオブジェクトからリッチ通知のURLを取得
    //    NSString* url = (NSString*) [userInfo objectForKey:@"url"];
    //
    //    if (url != nil && ![url isEqualToString:@""]) {
    //
    //        self.richUrl = url;
    //
    //        if ([self.richUrl hasPrefix:@"pass://"]) {
    //
    //            //Passbookの画面を表示
    //            self.passbookUrl = [self.richUrl stringByReplacingOccurrencesOfString:@"pass://" withString:@"http://"];
    //
    //            NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    //            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@からのお知らせ",appName] message:@"Passbookが届きました。\n表示しますか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"表示", nil];
    //            alert.tag = 8;
    //            [alert show];
    //            [alert release];
    //
    //        } else {
    //
    //            //リッチ通知の画面を表示
    //            [self showPopupView];
    //
    //        }
    //
    //        return;
    //    }
    //*********************************************************************************************
    
}

- (void)handleForegroundNotifcation:(NSDictionary*)userInfo {
        
    //*********************************************************************************************
    //    //アプリがフォアグランドで動作中に通知を受信した時の動作を定義
    //    
    //    // userInfoオブジェクトかリッチ通知のURLを取得
    //    NSString* url = (NSString*) [userInfo objectForKey:@"url"];
    //    
    //    if (url != nil && ![url isEqualToString:@""]) {
    //        
    //        self.richUrl = url;
    //                  
    //        if ([self.richUrl hasPrefix:@"pass://"]) {
    //            
    //            //Passbookの画面を表示
    //            self.passbookUrl = [self.richUrl stringByReplacingOccurrencesOfString:@"pass://" withString:@"http://"];
    //            
    //            NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    //            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@からのお知らせ",appName] message:@"Passbookが届きました。\n表示しますか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"表示", nil];
    //            alert.tag = 8;
    //            [alert show];
    //            [alert release];
    //            
    //        } else {
    //            
    //            //リッチ通知の画面を表示
    //            [self showPopupView];
    //            
    //        }
    //        return;
    //    }
    //    
    //    
    //    // リッチ通知ではない場合
    //    // userInfoオブジェクトから通知メッセージを取得
    //    NSString* message = (NSString*) [[userInfo objectForKey:@"aps"] objectForKey:@"alert"];
    //    
    //    //通知のアラートを明示的に表示(アラートのタイトルはplistに定義されたアプリ名を使用)
    //    NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    //    UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:appName
    //                                                        message:message delegate:self
    //                                              cancelButtonTitle:nil
    //                                              otherButtonTitles:@"OK", nil];
    //    [alertView show];
    //    [alertView release];
    //*********************************************************************************************

}


- (void)handleLaunchingNotification:(NSDictionary*)userInfo {
    
    //*********************************************************************************************
    //    //アプリが起動中でない状態で通知からアプリを起動した場合に呼び出される。
    //
    //    // userInfoオブジェクトからリッチ通知のURLを取得
    //    NSString* url = (NSString*) [userInfo objectForKey:@"url"];
    //
    //    if (url != nil && ![url isEqualToString:@""]) {
    //
    //        self.richUrl = url;
    //
    //        if ([self.richUrl hasPrefix:@"pass://"]) {
    //
    //            //Passbookの画面を表示
    //            self.passbookUrl = [self.richUrl stringByReplacingOccurrencesOfString:@"pass://" withString:@"http://"];
    //
    //            NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    //            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@からのお知らせ",appName] message:@"Passbookが届きました。\n表示しますか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"表示", nil];
    //            alert.tag = 8;
    //            [alert show];
    //            [alert release];
    //
    //        } else {
    //
    //            //リッチ通知の画面を表示
    //            [self showPopupView];
    //
    //        }
    //
    //        return;
    //    }
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
    if ([[CorePushManager shared] pushEnabled]) {
        //フォアグランド起動時にデバイストークンを送信
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* deviceToken = [defaults objectForKey:CorePushDeviceTokenKey];
        
        if (deviceToken != nil && ![deviceToken isEqualToString:@""]) {
            [[CorePushManager shared] registerDeviceTokenString:deviceToken];
        }
    }
    
}

//リッチ通知の画面を表示
- (void)showPopupView {
    UIWindow* window = (UIWindow*)[[UIApplication sharedApplication] delegate].window;
    CorePushPopupView* popupView=[[CorePushPopupView alloc] initWithFrame:CGRectMake(0, 100, 300, 400)
                                                           withParentView:window];
    NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    popupView.titleBarText = [NSString stringWithFormat:@"%@からのお知らせ", appName];
    popupView.center = window.center;
    [popupView buildLayoutSubViews];
    UIWebView* webView =[[UIWebView alloc] initWithFrame:CGRectMake(0,0,
                                                                    popupView.contentView.frame.size.width,
                                                                    popupView.contentView.frame.size.height)];
    NSString *urlAddress = self.richUrl;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    webView.scalesPageToFit=YES;
    [popupView.contentView addSubview:webView];
    [webView release];
    
    UIButton* safariLaunchButton =[UIButton buttonWithType:UIButtonTypeCustom];
    safariLaunchButton.frame = CGRectMake(0,0,
                                          popupView.contentView.frame.size.width,
                                          popupView.contentView.frame.size.height);
    safariLaunchButton.backgroundColor=[UIColor clearColor];
    [safariLaunchButton addTarget:self action:@selector(safariLaunch:) forControlEvents:UIControlEventTouchUpInside];
    
    [popupView.contentView addSubview:safariLaunchButton];
    
    [popupView show];
}



// Passbookを表示
- (void)showPassbook {
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    // OSのバージョンが6以上の場合、Passbookを表示
    if (version  >= 6.00) {
        
        if ([PKPassLibrary isPassLibraryAvailable]) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^(void) {
                
                NSURL* pkPassUrl = [NSURL URLWithString:self.passbookUrl];
                
                NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:pkPassUrl];
                [urlRequest setHTTPMethod:@"GET"];
                NSString *userAgent = @"iPhone OS 6";
                [urlRequest setValue:userAgent forHTTPHeaderField:@"User-Agent"];
                NSURLResponse *response;
                NSError *error = nil;
                NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest
                                                     returningResponse:&response
                                                                 error:&error];
                
                if (error) {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    return;
                }
                
                PKPass* pkPass = [[PKPass alloc] initWithData:data error:&error];
                if (!error) {
                    PKAddPassesViewController* addCtrl = [[PKAddPassesViewController alloc] initWithPass:pkPass];
                    addCtrl.delegate = self;
                    [self.window.rootViewController presentModalViewController:addCtrl animated:YES];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(),^ {
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                } );
                
            });
            
        }
    } else {
        //        //OSのバージョンが6.0未満の場合の処理を記述
        //        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.passbookUrl]];
    }
    
}


-(void)addPassesViewControllerDidFinish:(PKAddPassesViewController *)controller {
    [self.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
}

//リッチ通知の画面をタップ時に呼びだされる。
- (void)safariLaunch:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"確認"
                                                    message:@"safariを起動します。\nよろしいでしょうか。"
                                                   delegate:self
                                          cancelButtonTitle:@"キャンセル"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 9;
    [alert show];
    [alert release];
}

#pragma mark - アラートのデリゲート
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 8) {
        if (buttonIndex == 1) {
            
            //PassbookのURLを表示
            [self showPassbook];
        }
    } else if (alertView.tag ==  9) {
        if (buttonIndex == 1) {
            //Safariでリッチ通知のURLを表示
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.richUrl]];
        }
    }
}


@end
