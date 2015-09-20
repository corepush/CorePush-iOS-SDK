//
//  CorePushNotificationHistoryManager.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePushNotificationHistoryRequest.h"

@protocol CorePushNotificationHistoryManagerDelegate;

/**
 * 通知履歴のマネージャークラス
 */
@interface CorePushNotificationHistoryManager : NSObject<CorePushNotificationHistoryRequestDelegate> {
    NSMutableArray *notificationHistoryModelArray_;
    CorePushNotificationHistoryRequest* request_;
    id <CorePushNotificationHistoryManagerDelegate> delegate_;
}

/// 通知履歴を格納した CorePushNotificationHistoryModelオブジェクトの配列
@property (nonatomic, retain) NSMutableArray *notificationHistoryModelArray;

/// CorePushNotificationHistoryManagerDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id <CorePushNotificationHistoryManagerDelegate> delegate;

/**
 * シングルトンの生成
 */
+ (id) shared;

/**
 * 通知履歴を取得する。
 * 取得に成功した場合は CorePushNotificationHistoryManagerDelegate#notificationHistoryManagerSuccess が呼ばれる。
 * 取得に失敗した場合は CorePushNotificationHistoryManagerDelegate#notificationHistoryManagerFail が呼ばれる。
 */
- (void) requestNotificationHistory;

/**
 * 指定の履歴IDのメッセージを既読に設定する。
 * @param historyId 履歴ID
 */
- (void) setRead:(NSString*)historyId;

/**
 * 指定の履歴IDのメッセージが未読であるかを判定する。
 * @param historyId 履歴ID
 */
- (BOOL) isUnread:(NSString*)historyId;

/**
 * 通知履歴の未読数を返す。
 */
- (int) getUnreadNumber;

@end

/**
 * CorePushNotificationHistoryManagerDelegateのデリゲートプロトコル
 */
@protocol  CorePushNotificationHistoryManagerDelegate <NSObject>
@required

//通知履歴の取得成功
- (void)notificationHistoryManagerSuccess;

//通知履歴の取得失敗
- (void)notificationHistoryManagerFail;

@end
