//
//  CorePushUnregisterTokenRequest.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CorePushUnregisterTokenRequestDelegate;

/**
 * CORE PUSHのデバイストークン削除クラス
 */
@interface CorePushUnregisterTokenRequest : NSObject {
    NSURLConnection* connection_;
    NSMutableData* receivedData_;
    
    id<CorePushUnregisterTokenRequestDelegate> delegate_;
}

@property (nonatomic, readonly) NSMutableData* receivedData;

/// CorePushUnregisterTokenRequestDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id<CorePushUnregisterTokenRequestDelegate> delegate;

/**
 * CORE PUSHからデバイストークンを削除する
 * @param token デバイストークン
 * @param configKey CORE PUSHのコンフィグキー
 */
- (void)request:(NSString*)token configKey:(NSString*)configKey;

@end

/**
 * CorePushUnregisterTokenRequestクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol CorePushUnregisterTokenRequestDelegate <NSObject>

/**
 * CORE PUSHからデバイストークンの削除が成功した時に呼ばれる
 */
- (void)unregisterTokenRequestSuccess;

/**
 * CORE PUSHからデバイストークンの削除が失敗した時に呼ばれる
 */
- (void)unregisterTokenRequestFail;
@end