//
//  CorePushRegisterUserAttributesRequest.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CorePushRegisterUserAttributesRequestDelegate;

/**
 * ユーザー属性情報の登録クラス
 */
@interface CorePushRegisterUserAttributesRequest : NSObject {
    NSURLConnection* connection_;
    NSMutableData* receivedData_;
    NSURL* requestURL_;
    id<CorePushRegisterUserAttributesRequestDelegate> delegate_;
    
}

@property (nonatomic, readonly) NSMutableData* receivedData;
@property (nonatomic, retain) NSURL *requestURL;

/// CorePushRegisterUserAttributesRequestDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id<CorePushRegisterUserAttributesRequestDelegate> delegate;

/**
 * ユーザー属性を登録します。
 * @param attributes ユーザー属性文字列の配列。
 */
- (void)requestWithAttributes:(NSArray*)attributes;

/**
 * オブジェクトを初期化する
 * @param urlString ユーザー属性を送信するURL。
 */
- (id)initWithURLString:(NSString*)urlString;

@end

/**
 * CorePushRegisterUserAttributesRequestクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol CorePushRegisterUserAttributesRequestDelegate <NSObject>

/**
 * CORE PUSHからデバイストークンの登録が成功した時に呼ばれる
 */
- (void)registerUserAttributesRequestSuccess;

/**
 * CORE PUSHからデバイストークンの登録が失敗した時に呼ばれる
 */
- (void)registerUserAttributesRequestFail;
@end