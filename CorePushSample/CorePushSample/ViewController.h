//
//  ViewController.h
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
    // プッシュ通知のON•OFFスイッチ
    IBOutlet UISwitch* notificationSwitch_;

    // デリゲートクラス
    id delegate_;
}

@property (retain, nonatomic) UISwitch* notificationSwtich;
@property (assign, nonatomic) id delegate;


// スイッチをON•OFFに切り替えた時に呼ばれる
- (IBAction)valueChangeNotificationSwitch:(id)sender;

@end
