//
//  AppDelegate.h
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePush/CorePushManager.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CorePushManagerDelegate> {
    
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController* tabBarController;
@property (retain, nonatomic) NSString* richUrl;

@end
