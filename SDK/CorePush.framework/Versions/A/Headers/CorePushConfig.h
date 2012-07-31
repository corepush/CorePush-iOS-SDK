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


/// デバイストークン登録・削除API
extern NSString* CorePushRegistTokenApi;    

/// コンフィグキーを保持するための UserDefaults のキー
extern NSString* CorePushConfigKey;

/// プッシュ通知の有効状態を保持するための UserDefadefaults のキー
extern NSString* CorePushPushEnabledKey;

/// デバイストークンの文字列を保持するための UserDefaults のキー
extern NSString* CorePushDeviceTokenKey;     

