# Core Push iOS SDK

##概要

Core Push iOS SDK は、プッシュ通知ASPサービス「CORE PUSH」の iOS用のSDKになります。 ドキュメントは CORE PUSH Developer サイトに掲載しております。

 
■公式サイト

CORE PUSH：<a href="http://core-asp.com">http://core-asp.com</a>

CORE PUSH Developer（開発者向け）：<a href="http://developer.core-asp.com">http://developer.core-asp.com</a>## 動作条件* iOS4.0以上が動作対象になります。
* Xcodeのプロジェクトのターゲットを選択し、Build Phases の Link Binary With Libraries から SDK/CorePush.framework を追加してください。	##アプリの通知設定###CORE PUSHの設定キーの指定Core Push管理画面 にログインし、ホーム画面からiOSアプリの設定キーを確認してください。 この設定キーをCorePushManager#setConfigKey で指定します。
	[[CorePushManager shared] setConfigKey:@"XXXXXXXXXX"];###CorePushManagerクラスのデリゲートクラスの指定
アプリケーションの動作状態に応じて通知をハンドリングするために、CorePushManagerDelegateプロトコルを実装した
クラスを CorePushManager#setDelegate で指定します。	 [[CorePushManager shared] setDelegate:self];     ##デバイスの通知登録解除デバイスが通知を受信できるようにするには、CORE PUSH にデバイストークンを送信します。またデバイスが通知を受信できないようにするには、CORE PUSH からデバイストークンを削除します。###通知登録
CorePushManager#registerForRemoteNotifications を呼び出すことで APNSサーバからデバイストークンを取得し、
デバイストークンを CORE PUSH に送信します。
	[[CorePushManager shared] registerForRemoteNotifications];
本メソッドはアプリの初回起動時かON/OFFスイッチなどで通知をONにする場合に使用してください。	###通知解除
CorePushManager#unregisterDeviceToken を呼び出すことで CORE PUSH からデバイストークンを削除します。
	[[CorePushManager shared] unregisterDeviceToken];
本メソッドはON/OFFスイッチなどで通知をOFFにする場合に使用してください。		##通知受信後の動作設定
アプリケーションの動作状態に応じて通知をハンドリングすることができます。	###バックグランド状態で動作中に通知から起動した場合
UIApplication#application:didReceiveRemoteNotification: にて、以下のメソッドを呼び出します。
	[[CorePushManager shared] handleRemoteNotification:userInfo]		  アプリケーションがバックグランド状態で動作中の場合は、CorePushManagerDelegate#handleBackgroundNotification が呼び出されます。###フォアグラウンド状態で動作中に通知を受信した場合
UIApplication#application:didReceiveRemoteNotification: にて、以下のメソッドを呼び出します。
	[[CorePushManager shared] handleRemoteNotification:userInfo]
アプリケーションがフォアグラウンド状態で動作中の場合は、CorePushManagerDelegate#handleForegroundNotification が呼び出されます。
###アプリケーションが動作していない状態で通知から起動した場合
UIApplication#application:didFinishLaunchingWithOptions にて、以下のメソッドを呼び出します。

	[[CorePushManager shared] handleLaunchingNotificationWithOption:launchOptions];

アプリケーションが動作していない状態で通知から起動した場合はCorePushManagerDelegate#handleLaunchingNotification が呼び出されます。	
	
	