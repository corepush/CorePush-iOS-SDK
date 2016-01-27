//
//  CorePushNotificationHistoryModel.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 通知履歴のモデルクラス
 */
@interface CorePushNotificationHistoryModel : NSObject {
    NSString* historyId_;
    NSString* message_;
    NSString* url_;
    NSString* regDate_;
}

/// 履歴ID
@property (nonatomic, retain) NSString* historyId;

/// 通知メッセージ
@property (nonatomic, retain) NSString* message;

/// 通知URL
@property (nonatomic, retain) NSString* url;

/// 通知日
@property (nonatomic, retain) NSString* regDate;

@end
