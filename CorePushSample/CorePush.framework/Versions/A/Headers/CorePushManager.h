//
//  CorePushManager.h
//  CorePush
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CorePushRegisterTokenRequest.h"
#import "CorePushUnregisterTokenRequest.h"
#import "CorePushRegisterUserAttributesRequest.h"
#import <CoreLocation/CoreLocation.h>

/**
 * CorePushManagerクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol CorePushManagerDelegate <NSObject>

@optional

/**
 * アプリがバックグランドで動作中に通知からアプリを起動した時に CorePushManager#handleRemoteNotification から呼び出されます。
 * @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleBackgroundNotification:(nonnull NSDictionary*)userInfo;

/**
 * アプリがフォアグランドで動作中に通知を受信した時に CorePushManager#handleRemoteNotification から呼び出されます。
 * @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleForegroundNotifcation:(nonnull NSDictionary*)userInfo;

/**
 * アプリのプロセスが起動していない状態で通知からアプリを起動した時に CorePushManager#handleLaunchingNotificationWithOption から呼び出されます。<br>
 * @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleLaunchingNotification:(nonnull NSDictionary*)userInfo;

@end

/**
 * CORE PUSHのマネジャークラス
 */
@interface CorePushManager : NSObject <CorePushManagerDelegate, CorePushRegisterTokenRequestDelegate, CorePushUnregisterTokenRequestDelegate, CorePushRegisterUserAttributesRequestDelegate, CLLocationManagerDelegate> {
 
    id<CorePushManagerDelegate> delegate_;
    
    NSString* configKey_;
    BOOL pushEnabled_;
    BOOL debugEnabled_;
    BOOL deviceIdEnabled_;
    BOOL deviceIdHashEnabled_;
    BOOL locationServiceEnabled_;
    NSMutableArray* categoryIds_;
    NSMutableDictionary* multiCategoryIds_;
    NSString* appUserId_;
    CLLocation* currentLocation_; // 現在の緯度経度
    CLLocationManager *locationManager_;
}

@property (nonatomic, retain, nullable) NSString* configKey;
@property (nonatomic, assign) BOOL pushEnabled;
@property (nonatomic, assign) BOOL debugEnabled;
@property (nonatomic, assign) BOOL deviceIdEnabled;
@property (nonatomic, assign) BOOL deviceIdHashEnabled;
@property (nonatomic, assign) BOOL locationServiceEnabled;
@property (nonatomic, retain, nullable) NSMutableArray* categoryIds;
@property (nonatomic, retain, nullable) NSMutableDictionary *multiCategoryIds;
@property (nonatomic, retain, nullable) NSString* appUserId;
@property (nonatomic, retain, nullable) CLLocation* currentLocation;
@property (nonatomic, retain, nullable) CLLocationManager *locationManager;
@property (nonatomic, readonly, nonnull) NSString* uuid;


/// CorePushManagerDelegateプロトコルを実装したクラス
@property (nonatomic, assign, nullable) id<CorePushManagerDelegate> delegate;

/**
 * シングルトンインスタンスの生成
 */
+ (nonnull id)shared;

/**
 * アプリケーションアイコンのバッジ数をリセットする
 */
+ (void)resetApplicationIconBadgeNumber;

/**
 * アプリケーションアイコンのバッジ数を設定する。
 * @param number バッジ数
 */
+ (void)setApplicationIconBadgeNumber:(int)number;

/**
 * CORE PUSHのコンフィグキーを設定する
 * @param configKey CORE PUSHのコンフィグキーの値。<br>指定したコンフィグキーは UserDefaultsに CorePushConfigKey のキーで保存されます。
 */
- (void)setConfigKey:(nullable NSString *)configKey;

/**
 * CORE PUSHの通知設定の有無を設定する
 * @param pushEnabled CORE PUSHの通知設定が有効な場合は YES、無効な場合は NO を設定する。<br>指定した値は UserDefaultsに CorePushPushEnabledKey のキーで保存されます。
 */
- (void)setPushEnabled:(BOOL)pushEnabled;

/**
 * CORE PUSHのデバッグログを出力する
 * @param debugEnabled デバッグログを出力する場合は YES、出力しない場合は NOを設定する
 */
- (void)setDebugEnabled:(BOOL)debugEnabled;

/**
 * デバイスIDをCORE PUSHサーバに送信するかを設定する。
 * @param deviceIdEnabled デバイスIDを送信する場合は YES、送信しない場合は NOを設定する。デフォルト値は NO。
 */
- (void)setDeviceIdEnabled:(BOOL)deviceIdEnabled;

/**
 * デバイスIDをMD5ハッシュ化の有無を設定する。
 * @param deviceIdHashEnabled ハッシュ化する場合は YES、ハッシュ化しない場合はNOを設定する。デフォルト値は NO。
 */
- (void)setDeviceIdHashEnabled:(BOOL)deviceIdHashEnabled;

/**
 * CORE PUSHのカテゴリIDを設定する。
 * @param categoryIds カテゴリIDの配列
 */
- (void)setCategoryIds:(nullable NSMutableArray *)categoryIds;

/**
 * CORE PUSHのカテゴリIDを設定する。
 * @param multiCategoryIds カテゴリIDのディクショナリ。カテゴリIDをキーにサブカテゴリID
 * の配列を指定。
 */
- (void)setMultiCategoryIds:(nullable NSMutableDictionary *)multiCategoryIds;

/**
 * CORE PUSHのユーザーIDを設定する。
 * @param appUserId アプリのユーザーID。
 */
- (void)setAppUserId:(nullable NSString*)appUserId;


/**
 * 現在の位置情報を送信する。
 */
- (void)reportCurrentLocation;

/**
 * APNSの通知サービスにデバイスを登録する。
 * デフォルトでは通知のアラート、バッジ、サウンドをONに設定
 */
- (void)registerForRemoteNotifications;

/**
 * APNSの通知サービスにデバイスを登録する。
 * @param types 通知タイプ
 */
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types;

/**
 * CORE PUSHにデバイストークンを登録する。<br>
 * 変換したデバイストークンの文字列は UserDefaultsに CorePushDeviceTokenKeyキー で保存されます。<br>
 * デバイストークンの登録が成功した場合は CorePushManagerRegisterTokenRequestSuccessNotification の通知キーで NSNotificationCenter に
 * 通知を行います。<br>
 * デバイストークンの登録が失敗した場合は CorePushManagerRegisterTokenRequestFailNotification の通知キーで NSNotificationCenterに通知を行います。<br>
 * @param token APNSサーバから取得したデバイストークンのバイト列。
 */
- (void)registerDeviceToken:(nonnull NSData *)token;


/**
 * CORE PUSHにデバイストークンを登録する。<br>
 * 変換したデバイストークンの文字列は UserDefaultsに CorePushDeviceTokenKeyキー で保存されます。<br>
 * デバイストークンの登録が成功した場合は CorePushManagerRegisterTokenRequestSuccessNotification の通知キーで NSNotificationCenter に
 * 通知を行います。<br>
 * デバイストークンの登録が失敗した場合は CorePushManagerRegisterTokenRequestFailNotification の通知キーで NSNotificationCenterに通知を行います。<br>
 * @param token APNSサーバから取得したデバイストークンの文字列。
 */
- (void)registerDeviceTokenString:(nonnull NSString *)token;


/**
 * CORE PUSHからデバイストークンを削除する<br>
 * デバイストークン削除時に UserDefaults の CPDeviceTokenキー に保存されたデバイストークンを空文字で保存します。<br>
 * デバイストークンの削除が成功した場合は CorePushManagerUnregisterTokenRequestSuccessNotification の通知キーで NSNotificationCenter に通知を行います。<br>
 * デバイストークンの削除が失敗した場合は CorePushManagerUnregisterTokenRequestFailNotification の通知キーで NSNotificationCenter に通知を行います。
 */
- (void)unregisterDeviceToken;


/**
 * 指定のURLにユーザー属性を送信する。
 * @param attributes ユーザー属性の配列
 * @param url ユーザー属性を送信するurl
 */
- (void)registerUserAttributes:(nonnull NSArray*)attributes api:(nonnull NSString*)url;

/**
 * アプリがフォアグランド・バックグランド状態で動作中に通知を受信した時の動作を定義する。<br>
 * バックラウンド状態で通知を受信後に通知からアプリを起動した場合、
 * CorePushManagerDelegate#handleBackgroundNotificationが呼び出されます。<br>
 * フォアグランド状態で通知を受信した場合、CorePushManagerDelegate#handleForegroundNotificationが呼び出されます。
 * @param userInfo 通知の情報を含むオブジェクト
 */
- (void)handleRemoteNotification:(nonnull NSDictionary*)userInfo;


/**
 * アプリのプロセスが起動していない状態で通知からアプリを起動した時の処理を定義する。<br>
 * launchOptionsに通知のUserInfoが存在する場合は、CorePushManagerDelegate#handleLaunchingNotificationを
 * 呼び出し、存在しない場合は何も行わない。
 * @param launchOptions 起動オプション。UIApplicationLaunchOptionsRemoteNotificationKeyをキーにUserInfoオブジェクトを取得する
 */
- (void)handleLaunchingNotificationWithOption:(nonnull NSDictionary*)launchOptions;

@end
