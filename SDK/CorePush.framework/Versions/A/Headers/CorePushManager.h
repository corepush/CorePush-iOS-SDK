//
//  CorePushManager.h
//  CorePush
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CorePushRegisterTokenRequest.h"
#import "CorePushUnregisterTokenRequest.h"

/**
 * CorePushManagerクラスのデリゲートメソッドを定義したプロトコル
 */
@protocol CorePushManagerDelegate <NSObject>

@optional

/**
 * アプリがバックグランドで動作中に通知からアプリを起動した時に CorePushManager#handleRemoteNotification から呼び出されます。
 * @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleBackgroundNotification:(NSDictionary*)userInfo;

/**
 * アプリがフォアグランドで動作中に通知を受信した時に CorePushManager#handleRemoteNotification から呼び出されます。
 * @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleForegroundNotifcation:(NSDictionary*)userInfo;

/**
 * アプリのプロセスが起動していない状態で通知からアプリを起動した時に CorePushManager#handleLaunchingNotificationWithOption から呼び出されます。<br>
 * @param userInfo 通知情報を含むオブジェクト
 */
- (void)handleLaunchingNotification:(NSDictionary*)userInfo;

@end

/**
 * CORE PUSHのマネジャークラス
 */
@interface CorePushManager : NSObject <CorePushManagerDelegate, CorePushRegisterTokenRequestDelegate, CorePushUnregisterTokenRequestDelegate> {
 
    id<CorePushManagerDelegate> delegate_;
    
    NSString* configKey_;
    BOOL pushEnabled_;
    BOOL debugEnabled_;
    
}

@property (nonatomic, retain) NSString* configKey;
@property (nonatomic, assign) BOOL pushEnabled;
@property (nonatomic, assign) BOOL debugEnabled;


/// CorePushManagerDelegateプロトコルを実装したクラス
@property (nonatomic, assign) id<CorePushManagerDelegate> delegate;

/**
 * シングルトンインスタンスの生成
 */
+ (id)shared;

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
 * @param　configKey CORE PUSHのコンフィグキーの値。<br>指定したコンフィグキーは UserDefaultsに CorePushConfigKey のキーで保存されます。
 */
- (void)setConfigKey:(NSString *)configKey;

/**
 * CORE PUSHの通知設定の有無を設定する
 * @param pushEnabled CORE PUSHの通知設定が有効な場合は YES、無効な場合は NO を設定する。<br>指定した値は UserDefaultsに CorePushPushEnabledKey のキーで保存されます。
 */
- (void)setPushEnabled:(BOOL)pushEnabled;

/**
 * CORE PUSHのデバッグログを出力する
 * @param debugEnable デバッグログを出力する場合は YES、出力しない場合は NOを設定する
 */
- (void)setDebugEnabled:(BOOL)debugEnabled;

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
- (void)registerDeviceToken:(NSData *)token;

/**
 * CORE PUSHからデバイストークンを削除する<br>
 * デバイストークン削除時に UserDefaults の CPDeviceTokenキー に保存されたデバイストークンを空文字で保存します。<br>
 * デバイストークンの削除が成功した場合は CorePushManagerUnregisterTokenRequestSuccessNotification の通知キーで NSNotificationCenter に通知を行います。<br>
 * デバイストークンの削除が失敗した場合は CorePushManagerUnregisterTokenRequestFailNotification の通知キーで NSNotificationCenter に通知を行います。
 */
- (void)unregisterDeviceToken;

/**
 * アプリがフォアグランド・バックグランド状態で動作中に通知を受信した時の動作を定義する。<br>
 * バックラウンド状態で通知を受信後に通知からアプリを起動した場合、
 * CorePushManagerDelegate#handleBackgroundNotificationが呼び出されます。<br>
 * フォアグランド状態で通知を受信した場合、CorePushManagerDelegate#handleForegroundNotificationが呼び出されます。
 * @param userInfo 通知の情報を含むオブジェクト
 */
- (void)handleRemoteNotification:(NSDictionary*)userInfo;


/**
 * アプリのプロセスが起動していない状態で通知からアプリを起動した時の処理を定義する。<br>
 * launchOptionsに通知のUserInfoが存在する場合は、CorePushManagerDelegate#handleLaunchingNotificationを
 * 呼び出し、存在しない場合は何も行わない。
 * @param launchOptions 起動オプション。UIApplicationLaunchOptionsRemoteNotificationKeyをキーにUserInfoオブジェクトを取得する
 */
- (void)handleLaunchingNotificationWithOption:(NSDictionary*)launchOptions;


@end
