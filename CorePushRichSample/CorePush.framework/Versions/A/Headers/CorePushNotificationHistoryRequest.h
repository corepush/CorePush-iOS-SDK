//
//  CorePushNotificationHistoryRequest.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol CorePushNotificationHistoryRequestDelegate;

/**
 * 通知履歴の取得を行うクラス
 */
@interface CorePushNotificationHistoryRequest : NSObject {
    NSMutableArray* notificationHistoryModelArray_;
    NSURLConnection* connection_;
    NSMutableData* receivedData_;
    id<CorePushNotificationHistoryRequestDelegate> delegate_;
}

@property (nonatomic, readonly) NSMutableData* receivedData;

/// 通知履歴を格納した CorePushNotificationHistoryオブジェクトの配列
@property (nonatomic, retain) NSMutableArray* notificationHistoryModelArray;

/// CorePushNotificationHistoryRequestDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id<CorePushNotificationHistoryRequestDelegate> delegate;

/**
 * 通知履歴をリクエスト
 * @param configKey 設定キー
 */
- (void)requestNotificationHistory:(NSString*)configKey;

/**
 * 通知履歴のキャンセル
 */
- (void)cancelNotificationHistoryRequest;

@end

/**
 * CorePushNotificationHistoryRequestクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol  CorePushNotificationHistoryRequestDelegate <NSObject>
@required

//通知履歴の取得成功
- (void)notificationHistoryRequestSuccess;

//通知履歴の取得失敗
- (void)notificationHistoryRequestFail;

@end
