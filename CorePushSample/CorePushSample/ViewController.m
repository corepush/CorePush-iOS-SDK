//
//  ViewController.m
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import <CorePush/CorePushConfig.h>
#import <CorePush/CorePushManager.h>

@implementation ViewController

@synthesize notificationSwtich = notificationSwitch_;
@synthesize delegate = delegate_;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [notificationSwitch_ release];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //*********************************************************************************************
    // デバイストークの登録・削除時の通知をNotificationCenterに登録する。
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerTokenRequestSuccess) name:CorePushManagerRegisterTokenRequestSuccessNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registerTokenRequestFail) name:CorePushManagerRegisterTokenRequestFailNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unregisterTokenRequestSuccess) name:CorePushManagerUnregisterTokenRequestSuccessNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unregisterTokenRequestFail) name:CorePushManagerUnregisterTokenRequestFailNotification object:nil];
    //*********************************************************************************************
 
    
    
    BOOL pushEnabled = [[CorePushManager shared] pushEnabled];
    if (pushEnabled) {
        notificationSwitch_.on = YES;
    } else {
        notificationSwitch_.on = NO;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //*********************************************************************************************
    // NotificationCenterからデバイストークの登録・削除時の通知を解除する。
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerRegisterTokenRequestSuccessNotification object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerRegisterTokenRequestFailNotification object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerUnregisterTokenRequestSuccessNotification object:nil];
    // [[NSNotificationCenter defaultCenter] removeObserver:self name:CorePushManagerUnregisterTokenRequestFailNotification object:nil];
    //*********************************************************************************************
}

// プッシュ通知のON•OFFを切り替えたときに呼ばれる。
- (IBAction)valueChangeNotificationSwitch:(id)sender {
    if (notificationSwitch_.on) {
        
        //*********************************************************************************************
        // プッシュ通知の有効化フラグをYESに設定
        //*********************************************************************************************
        [[CorePushManager shared] setPushEnabled:YES];
        
        //*********************************************************************************************
        // 通知の登録・デバイストークンをcore-aspサーバに登録
        //*********************************************************************************************
        [[CorePushManager shared] registerForRemoteNotifications];
        
    } else {

        //*********************************************************************************************
        // プッシュ通知の有効化フラグをNOに設定
        //*********************************************************************************************
        [[CorePushManager shared] setPushEnabled:NO];
        
        
        //*********************************************************************************************
        // デバイストークンをcore-aspサーバから削除
        //*********************************************************************************************
        [[CorePushManager shared] unregisterDeviceToken];
    }
}

//*********************************************************************************************
// デバイストークン登録成功時に呼び出される。
// - (void)registerTokenRequestSuccess {
//    notificationSwitch_.on = YES;
//    
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"デバイストークンの登録に成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//    [alert show];
//    [alert release];
//}
//
// デバイストークン登録失敗に呼び出される。
//- (void)registerTokenRequestFail {
//    notificationSwitch_.on = NO;
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"デバイストークンの登録に失敗" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//    [alert show];
//    [alert release];
//}
//
// デバイストークン削除成功時に呼び出される。
//- (void)unregisterTokenRequestSuccess {
//    notificationSwitch_.on = NO;
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"デバイストークンの削除に成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//    [alert show];
//    [alert release];
//}
//
// デバイストークン削除失敗時に呼び出される。
//- (void)unregisterTokenRequestFail {
//    notificationSwitch_.on = YES;
//    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"エラー" message:@"デバイストークンの削除に失敗" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
//    [alert show];
//    [alert release];
//}
//
//*********************************************************************************************

@end
