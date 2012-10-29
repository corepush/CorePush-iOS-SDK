//
//  NotificationHistoryViewController.h
//  CorePushSample
//
//  Copyright (c) 2012年 株式会社ブレスサービス. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePush/CorePushNotificationHistoryManager.h>

@interface NotificationHistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, CorePushNotificationHistoryManagerDelegate> {
    UITableView* tableView_;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;

@end
