//
//  NotificationHistoryViewController.m
//  CorePushSample
//
//  Copyright (c) 2012年 株式会社ブレスサービス. All rights reserved.
//

#import "NotificationHistoryViewController.h"
#import <CorePush/CorePushNotificationHistoryModel.h>

@interface NotificationHistoryViewController ()

@end

@implementation NotificationHistoryViewController

@synthesize tableView = tableView_;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"通知履歴";
        self.tabBarItem.image = [UIImage imageNamed:@"history.png"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"通知履歴";
    self.tableView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[CorePushNotificationHistoryManager shared] setDelegate:self];
    
    // 通知履歴一覧を取得する
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[CorePushNotificationHistoryManager shared] requestNotificationHistory];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[CorePushNotificationHistoryManager shared] notificationHistoryModelArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }

    CorePushNotificationHistoryModel* historyModel = [[[CorePushNotificationHistoryManager shared] notificationHistoryModelArray] objectAtIndex:indexPath.row];
    cell.textLabel.text = historyModel.message;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
 
    CorePushNotificationHistoryModel* historyModel = [[[CorePushNotificationHistoryManager shared] notificationHistoryModelArray] objectAtIndex:indexPath.row];
    NSString* historyId = historyModel.historyId;
    
    //タップされた場合、該当する通知メッセージを既読に設定する。
    [[CorePushNotificationHistoryManager shared] setRead:historyId];
    
    //未読数をタブに設定する。
    [self setUnreadNumber];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [tableView_ reloadData];
}

//通知履歴の取得成功
- (void)notificationHistoryManagerSuccess {
    [self setUnreadNumber];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [tableView_ reloadData];
}

//通知履歴の取得失敗
- (void)notificationHistoryManagerFail {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

//未読数をタブに表示する。
- (void)setUnreadNumber {
    int unreadNumber = [[CorePushNotificationHistoryManager shared] getUnreadNumber];
    if (unreadNumber > 0) {
        self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unreadNumber];
        
    } else {
        self.tabBarItem.badgeValue = nil;
    }
}

- (void)dealloc {
    [tableView_ release], tableView_ = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
