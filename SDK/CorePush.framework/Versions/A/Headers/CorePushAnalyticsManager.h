//
//  CorePushAnalyticsManager.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CorePushAppLaunchAnalyticsRequest.h"

@protocol CorePushAnalyticsManagerDelegate;

/**
 * アクセス解析のマネージャークラス
 */
@interface CorePushAnalyticsManager : NSObject<CorePushAppLaunchAnalyticsRequestDelegate> {
    id <CorePushAnalyticsManagerDelegate> delegate_;
}


/// CorePushAnalyticsManagerDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id <CorePushAnalyticsManagerDelegate> delegate;

/**
 * シングルトンの生成
 */
+ (id) shared;

/**
 * 通知からのアプリ起動時のデータを送信する
 * 送信に成功した場合は CorePushAnalyticsManagerDelegate#analyticsManagerSuccess が呼ばれる。
 * 送信に失敗した場合は CorePushAnalyticsManagerDelegate#analyticsManagerFail が呼ばれる。
 */
- (void) requestAppLaunchAnalytics:(NSString*)pushId latitude:(NSString*)latitude longitude:(NSString*)longitude;

@end

/**
 * CorePushAnalyticsManagerDelegateのデリゲートプロトコル
 */
@protocol  CorePushAnalyticsManagerDelegate <NSObject>
@required


//アクセス解析の送信成功
- (void)analyticsManagerSuccess;

//アクセス解析の送信失敗
- (void)analyticsManagerFail;

@end
