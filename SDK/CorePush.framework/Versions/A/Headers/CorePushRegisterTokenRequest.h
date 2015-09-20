//
//  CorePushRegisterTokenRequest.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CorePushRegisterTokenRequestDelegate;

/**
 * CORE PUSHのデバイストークン登録クラス
 */
@interface CorePushRegisterTokenRequest : NSObject {
    NSURLConnection* connection_;
    NSMutableData* receivedData_;
    id<CorePushRegisterTokenRequestDelegate> delegate_;
}

@property (nonatomic, readonly) NSMutableData* receivedData;

/// CorePushRegisterTokenRequestDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id<CorePushRegisterTokenRequestDelegate> delegate;

/**
 * CORE PUSHにデバイストークンを登録します。
 * @param token デバイストークン
 * @param configKey CORE PUSHのコンフィグキーの値
 */
- (void)request:(NSString*)token configKey:(NSString*)configKey;

@end

/**
 * CorePushRegisterTokenRequestクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol CorePushRegisterTokenRequestDelegate <NSObject>

/**
 * CORE PUSHからデバイストークンの登録が成功した時に呼ばれる
 */
- (void)registerTokenRequestSuccess;

/**
 * CORE PUSHからデバイストークンの登録が失敗した時に呼ばれる
 */
- (void)registerTokenRequestFail;
@end