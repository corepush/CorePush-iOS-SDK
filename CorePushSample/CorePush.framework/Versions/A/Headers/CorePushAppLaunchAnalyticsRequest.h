//
//  CorePushAppLaunchAnalyticsRequest.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CorePushAppLaunchAnalyticsRequestDelegate;

/**
 * 通知からのアプリ起動のアクセス解析のリクエストを行うクラス
 */
@interface CorePushAppLaunchAnalyticsRequest : NSObject {
    NSURLConnection* connection_;
    NSMutableData* receivedData_;
    id<CorePushAppLaunchAnalyticsRequestDelegate> delegate_;
}

@property (nonatomic, readonly) NSMutableData* receivedData;

/// CorePushAppLaunchAnalyticsRequestDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id<CorePushAppLaunchAnalyticsRequestDelegate> delegate;

/**
 * アクセス解析をリクエスト
 * @param token デバイストークン
 * @param configKey コンフィグキー
 * @param pushId 通知ID
 * @param latitude 緯度
 * @param longitude 経度
 */
- (void)requestAnalytics:(NSString*)token configKey:(NSString*)configKey pushId:(NSString*)pushId latitude:(NSString*)latitude longitude:(NSString*)longitude;

/**
 * リクエストをキャンセル
 */
- (void)cancelAnalyticsRequest;

@end

/**
 * CorePushAppLaunchAnalyticsRequestクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol  CorePushAppLaunchAnalyticsRequestDelegate <NSObject>
@required

//アクセス解析の送信成功
- (void)appLaunchAnalyticsRequestSuccess;

//アクセス解析の送信失敗
- (void)appLaunchAnalyticsRequestFail;

@end
