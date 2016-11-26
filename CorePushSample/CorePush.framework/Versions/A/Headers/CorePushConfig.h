//
//  CorePushConfig.h
//  CorePush
//

#import <Foundation/Foundation.h>

/**
 * CORE PUSHのコンフィグクラス
 */


/// デバイストークン登録成功時の通知キー
extern NSString* CorePushManagerRegisterTokenRequestSuccessNotification;

/// デバイストークン登録失敗時の通知キー
extern NSString* CorePushManagerRegisterTokenRequestFailNotification;

/// デバイストークン削除成功時の通知キー
extern NSString* CorePushManagerUnregisterTokenRequestSuccessNotification;

/// デバイストークン削除失敗時の通知キー
extern NSString* CorePushManagerUnregisterTokenRequestFailNotification;

/// ユーザー属性の登録成功時の通知キー
extern NSString* CorePushManagerRegisterUserAttributesRequestSuccessNotification;

/// ユーザー属性の登録失敗時の通知キー
extern NSString* CorePushManagerRegisterUserAttributesRequestFailNotification;

/// デバイストークン登録・削除API
extern NSString* CorePushRegistTokenApi;

/// デバイストークン登録・削除API
extern NSString* CorePushNotificationHistoryApi;

/// アクセス解析API
extern NSString* CorePushAnalyticsApi;

/// コンフィグキーを保持するための UserDefaults のキー
extern NSString* CorePushConfigKey;

/// プッシュ通知の有効状態を保持するための UserDefadefaults のキー
extern NSString* CorePushPushEnabledKey;

/// デバッグの有効状態を保持するための UserDefadefaults のキー
extern NSString* CorePushDebugEnabledKey;

/// デバイスIDの有効状態を保持するための UserDefadefaults のキー
extern NSString* CorePushDeviceIdEnabledKey;

/// デバイスIDのハッシュ化の有効状態を保持するための UserDefadefaults のキー
extern NSString* CorePushDeviceIdHashEnabledKey;


/// デバイストークンの文字列を保持するための UserDefaults のキー
extern NSString* CorePushDeviceTokenKey;

/// CorePushのLocationServiceを保持するための UserDefaults のキー
extern NSString* CorePushLocationServiceEnabledKey;

/// アプリ内のユーザーIDを保持するための UserDefaults のキー
extern NSString* CorePushAppUserIdKey;

/// カテゴリIDを保持するための UserDefaults のキー
extern NSString* CorePushCategoryIdsKey;

/// 2次元カテゴリIDを保持するための UserDefaults のキー
extern NSString* CorePushMultiCategoryIdsKey;

// UUIDのUserDefaults のキー
extern NSString* CorePushUUID;

