# Core Push iOS SDK

##概要

Core Push iOS SDK は、プッシュ通知ASPサービス「CORE PUSH」の iOS用のSDKになります。 ドキュメントは CORE PUSH Developer サイトに掲載しております。

 
■公式サイト

CORE PUSH：<a href="http://core-asp.com">http://core-asp.com</a>

CORE PUSH Developer（開発者向け）：<a href="http://developer.core-asp.com">http://developer.core-asp.com</a>## 動作条件* iOS4.0以上が動作対象になります。
* Xcodeのプロジェクトのターゲットを選択し、Build Phases の Link Binary With Libraries から SDK/CorePush.framework を追加してください。
* リッチ通知をご利用の場合は、SDK/CorePush.framework と SDK/CorePushSDKResources.bundle を追加してください。リッチ通知のサンプルは、CorePushRichSampleプロジェクトをご参照ください。	##アプリの通知設定###CORE PUSHの設定キーの指定Core Push管理画面 にログインし、ホーム画面からiOSアプリの設定キーを確認してください。 この設定キーをCorePushManager#setConfigKey で指定します。
	[[CorePushManager shared] setConfigKey:@"XXXXXXXXXX"];###CorePushManagerクラスのデリゲートクラスの指定
アプリケーションの動作状態に応じて通知をハンドリングするために、CorePushManagerDelegateプロトコルを実装した
クラスを CorePushManager#setDelegate で指定します。	 [[CorePushManager shared] setDelegate:self];     ##デバイスの通知登録解除デバイスが通知を受信できるようにするには、CORE PUSH にデバイストークンを送信します。またデバイスが通知を受信できないようにするには、CORE PUSH からデバイストークンを削除します。###通知登録
CorePushManager#registerForRemoteNotifications を呼び出すことで APNSサーバからデバイストークンを取得し、デバイストークンを CORE PUSH に送信します。また、デバイストークンの送信時に 端末名、OSバージョン、最終利用時間を自動送信します。
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

##通知履歴の表示


###通知履歴の取得
CorePushNotificationHistoryManager#requestNotificationHistory を呼び出すことで通知履歴を最大100件取得できます。

    [[CorePushNotificationHistoryManager shared] requestNotificationHistory];

取得した通知履歴のオブジェクトの配列は、CorePushNotificationHistoryManager#notificationHistoryModelArray に格納されます。

    [[CorePushNotificationHistoryManager shared] notificationHistoryModelArray];
  
上記の配列により、個々の通知履歴の CorePushNotificationHistoryModel オブジェクトを取得できます。CorePushNotificationHistoryModelオブジェクトには、履歴ID、通知メッセージ、通知日時、リッチ通知URLが格納されます。

	// 例) 451
	NSString* historyId = notificationHistoryModel.historyId;
	
	// 例) CORE PUSH からのお知らせ!
	NSString* message = notificationHistoryModel.message;

	// 例) http://core-asp.com
	NSString* url = notificationHistoryModel.url;

	// 例) 2012-08-18 17:48:30
	NSString* regDate = notificationHistoryModel.regDate;
	
###通知履歴の未読管理
CorePushNotificationHistoryManager#setRead を呼び出すことで通知履歴の履歴ID毎に未読を管理することができます。以下は、ある履歴IDの
通知メッセージを既読に設定する例になります。

    //タップされた場合、該当する通知メッセージを既読に設定する。
    [[CorePushNotificationHistoryManager shared] setRead:historyId];

また、CorePushNotificationHistoryManager#getUnreadNumber を呼び出すことで 通知履歴の配列全体の未読数を取得することができます。

	[[CorePushNotificationHistoryManager shared] getUnreadNumber]
	
取得した未読数は、タブのバッジ数やアイコンのバッジ数などに用いることができます。

	 //タブのバッジ数に未読数を設定する場合
	 self.tabBarItem.badgeValue = [NSString stringWithFormat:@"%d", unreadNumber];
	 
	 //アイコンのバッジ数に未読数を設定する場合
	 [CorePushManager setApplicationIconBadgeNumber:unreadNumber];	
##リッチ通知画面(ポップアップウインドウ)の表示

リッチ通知を受信した場合は、通知オブジェクト内にリッチ通知用のURLが含まれます。
リッチ通知用のURLは、以下の方法で取得できます。

	NSString* url = (NSString*) [userInfo objectForKey:@"url"];
	
上記のURLをリッチ通知画面で表示するには、SDKのCorePushPopupViewオブジェクトを使用します。
以下は CorePushRichSampleプロジェクトからの抜粋になります。

	// ポップアップウインドウを追加する親ビューを取得
    UIWindow* window = (UIWindow*)[[UIApplication sharedApplication] delegate].window;
    
    // ポップアップウインドウの作成
    CorePushPopupView* popupView=[[CorePushPopupView alloc] initWithFrame:CGRectMake(0, 100, 300, 400)
                                                           withParentView:window];
                                                           
    // ポップアップウインドウのタイトルを設定                                                   
    NSString* appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    popupView.titleBarText = [NSString stringWithFormat:@"%@からのお知らせ", appName];
    
    // ポップアップウインドウの位置を親ビューの中心に設定
    popupView.center = window.center;
    
    // ポップアップビューのレイアウトを構築
    [popupView buildLayoutSubViews];
    
    // リッチ通知URLを表示するWebViewを作成
    UIWebView* webView =[[UIWebView alloc] initWithFrame:CGRectMake(0,0,
									popupView.contentView.frame.size.width,
									popupView.contentView.frame.size.height)];
    NSString *urlAddress = self.richUrl;
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [webView loadRequest:requestObj];
    webView.scalesPageToFit=YES;
    [popupView.contentView addSubview:webView];
    [webView release];
    
    // WebViewのコンテンツ画面をタップ時にSafariを起動するように設定
    UIButton* safariLaunchButton =[UIButton buttonWithType:UIButtonTypeCustom];
    safariLaunchButton.frame = CGRectMake(0,0,
                                          popupView.contentView.frame.size.width,
                                          popupView.contentView.frame.size.height);
    safariLaunchButton.backgroundColor=[UIColor clearColor];
    [safariLaunchButton addTarget:self action:@selector(safariLaunch:) forControlEvents:UIControlEventTouchUpInside];
    
    [popupView.contentView addSubview:safariLaunchButton];
    
    // ポップアップウインドウを表示
    [popupView show];


##現在位置情報の送信

CorePushManager#reportCurrentLocation 、現在の位置情報(緯度、経度)をパラメータに付加し、CORE PUSHサーバにデバイストークンの送信を行います。位置情報の取得するには プロジェクトに CoreLocation.framework を追加しておく必要があります。また、位置情報の送信を行うには、CorePushManager#setLocationServiceEnabled で位置情報の取得を有効化する必要があります。

    //現在地の位置情報を送信する。
    [[CorePushManager shared] setLocationServiceEnabled:YES];
    [[CorePushManager shared] reportCurrentLocation];

##カテゴリの設定
###１次元カテゴリ設定
デバイストークン登録APIの category_id パラメータの設定を行うことができます。パラメータの設定を行うには、
CorePushManager#setCategoryIds で カテゴリID(文字列型)のリストを指定します。以下はカテゴリIDのリストの作成例になります。<br />
※例は事前に管理画面で1から4までのカテゴリを設定しておいたものとする。

	//1:北海道、2:東北 3:関東、4:近畿
	 NSMutableArray* categoryids = [NSMutableArray arrayWithObjects:@"1", @"2", @"3", @"4", nil];
	[[CorePushManager shared] setCategoryIds:categoryids];

上記カテゴリの設定後にデバイストークンを送信した場合、設定したcategory_id パラメータの値をCORE PUSHサーバにPOSTします。
(category_idパラメータを設定しない場合のデフォルト値は 1 になります。)

###2次元カテゴリ設定
デバイストークン登録APIの category_id パラメータの設定を行うことができます。パラメータの設定を行うには、
CorePushManager#setMultiCategoryIds で カテゴリIDのディクショナリーを指定します。以下はカテゴリIDのディクショナリーの作成例になります。<br />
※例は事前に管理画面で1から4までのカテゴリを設定しておいたものとする。

	//1:地域、2:性別 3:年代 4:好きなジャンル(複数選択可の場合)
	 NSMutableDictionary* multiCategoryIds = [NSMutableDictionary dictionary];
	 [multiCategoryDictionary setObject:[NSArray arrayWithObjects:@"神奈川",nil] forKey:@"1"];         //地域が「神奈川」の場合
	 [multiCategoryDictionary setObject:[NSArray arrayWithObjects:@"男性",nil] forKey:@"2"];           //性別が「男性」の場合
	 [multiCategoryDictionary setObject:[NSArray arrayWithObjects:@"20代",nil] forKey:@"3"];           //年代が「男性」の場合
	 [multiCategoryDictionary setObject:[NSArray arrayWithObjects:@"音楽", @"読書", nil] forKey:@"4"];  //好きなジャンルが「音楽」と「読書」の場合
	[[CorePushManager shared] setMultiCategoryIds:multiCategoryids];

上記カテゴリの設定後にデバイストークンを送信した場合、設定したcategory_id パラメータの値をCORE PUSHサーバにPOSTします。
(1次元カテゴリと2次元カテゴリの両方が設定されている場合、category_id パラメータには２次元カテゴリの設定が優先されます。category_idパラメータを設定しない場合のデフォルト値は 1 になります。)


##端末情報の送信
CorePushManager#setDeviceIdEnabled で 端末ID(UDID)を送信を制御することができます。

	//端末IDを送信する場合
	[CorePushManager shared] setDeviceIdEnabled:YES];
	
また、CorePushManager#setDeviceIdHashEnabled で取得した端末IDをハッシュ化します。
	
	//端末IDをハッシュ化する場合
	[CorePushManager shared] setDeviceIdHashEnabled:YES];

##ユーザー間プッシュ通知
ユーザー間のプッシュ通知を実現するには、事前にアプリ側でユーザーのデバイストークンのCORE PUSHへの登録とユーザー属性の御社サーバへの登録を行う必要があります。全体のイメージ図につきましては、<a href="http://developer.core-asp.com/api_image.php">http://developer.core-asp.com/api_image.php</a> をご参照ください。
### CORE PUSHへのデバイストークンの登録

CorePushManager#registerForRemtoeNotifications で通知の登録を行う前に、CorePushManager#setAppUserIdでアプリ内のユーザーIDを指定します。
	//アプリのユーザーIDを登録	[[CorePushManager shared] setAppUserId:@"UserId"];	//デバイストークンの登録	[[CorePushManager shared] registerForRemoteNotifications];
  
上記により、api.core-asp.com/iphone_token_regist.php のトークン登録APIに
対して、app_user_id のパラメータが送信され、アプリ内でのユーザーの識別IDとデバイストークンが
紐づいた形でDBに保存されます。
  ### 御社サーバへのユーザー属性の登録
CorePushManager#registerUserAttributes:api: で御社サーバにユーザー属性の登録を行う前に
、CorePushManager#setAppUserIdでアプリ内でのユーザーの識別IDを指定します。	//アプリ内でのユーザーの識別IDを登録	[[CorePushManager shared] setAppUserId:@"UserId"];

ユーザー属性を定義した配列を作成します。
   
    //ユーザー属性の配列を作成。例) 1:いいね時の通知許可、3:コメント時の通知許可、7:フォロー時の通知許可
    NSArray* attributes = [NSArray arrayWithObjects:@"1",@"3",@"7", nil];

ユーザー属性を送信する御社サーバ上の任意のURLを指定します。

	//ユーザー属性を送信する御社の任意のURLを指定
    NSString* userAttributeApi = @"ユーザ属性を送信する御社の任意のURL";

作成したユーザー属性を定義した配列とユーザー属性を送信するAPIのURLを引数として CorePushManager#registerUserAttributes:api: を呼び出し、アプリ内でのユーザーの識別IDとユーザー属性を御社サーバに送信します。

	//アプリ内でのユーザーの識別IDとユーザー属性の送信
    [[CorePushManager shared] registerUserAttributes:attributes api:userAttributeApi];

特定のユーザーに対してプッシュ通知を行うには、通知送信リクエストAPIに対して、御社サーバから通知の送信依頼
を行います。詳細につきましては、<a href="http://developer.core-asp.com/api_request.php">http://developer.core-asp.com/api_request.php</a> をご参照ください。


## アクセス解析

### 通知からのアプリ起動数の把握

通知からのアプリの起動時にアクセス解析用のパラメータをCORE PUSHサーバに対して送信することで、管理画面の通知履歴から通知からのアプリ起動数を把握することができます。

アクセス解析用のパラメータを CORE PUSHサーバに対して送信するには、userInfo オブジェクトから push_id をキーとして通知IDを取得し、CorePushAnalyticsManager#requestAppLaunchAnalytics:latitude:longitude で
通知IDを送信します。

	// 通知IDの取得
    NSString* pushId = (NSString*) [userInfo objectForKey:@"push_id"];
    if (pushId != nil) {
    	 // 通知IDを送信します。通知IDは userInfoオブジェクトから push_id キーで
    	 // 取得できます。また、通知から起動した地点の緯度・経度を指定することができます。緯度・経度を
    	 // 送信しない場合は latitude、longitudeパラメータに 0 を指定します。
        [[CorePushAnalyticsManager shared] requestAppLaunchAnalytics:pushId latitude:@"0" longitude:@"0"];
    }

また、通知からの起動数を正確に把握するために、通知受信後の動作設定の項目で説明した以下の３つのメソッド内で
アクセス解析用のパラメータを CORE PUSHサーバに対して送信してください。

*	バックグランド状態で動作中に通知から起動した場合に呼び出されるCorePushManagerDelegate#handleBackgroundNotification メソッド*	フォアグラウンド状態で動作中に通知を受信した場合に呼び出される CorePushManagerDelegate#handleForegroundNotification *	アプリケーションが動作していない状態で通知から起動した場合に呼び出される　CorePushManagerDelegate#handleLaunchingNotification
## プッシュ通知の送信エラー

###エラー内容の把握

プッシュ通知の送信に失敗した場合、管理画面の送信履歴のエラー数のリンク先からエラー画面を確認できます。
エラー区分としては下記に分類されます。

1. アプリ削除でトークンが無効となった場合や、形式不正なトークンなどによるエラー
2. 上記以外のエラー（通信失敗、その他）

