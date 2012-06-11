//
//  ViewController.m
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

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

// プッシュ通知のON•OFFを切り替えたときに呼ばれる。
- (IBAction)valueChangeNotificationSwitch:(id)sender {
    if (notificationSwitch_.on) {
        
        // 通知サービスの登録
        // アラート、バッジ、サウンドの通知を有効化。
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert |
                                                                               UIRemoteNotificationTypeBadge |
                                                                               UIRemoteNotificationTypeSound) ];
    } else {
        
        // 通知サービスの解除
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];  
        
        // サーバからデバイストークンの削除
        if ([delegate_ isKindOfClass:[AppDelegate class]]) {
            AppDelegate* appDelegate = (AppDelegate*)delegate_;
            NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
            NSString* deviceToken = [defaults objectForKey:@"DEVICE_TOKEN_STRING"];
            [appDelegate removeDeviceTokenToServer:deviceToken];
        }
        
    }
}


@end
