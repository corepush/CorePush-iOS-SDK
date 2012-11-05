//
//  AppDelegate.h
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CorePush/CorePushManager.h>
#import <PassKit/PKPassLibrary.h>
#import <PassKit/PKPass.h>
#import <PassKit/PKAddPassesViewController.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate, CorePushManagerDelegate, PKAddPassesViewControllerDelegate> {
    
}

@property (retain, nonatomic) UIWindow *window;
@property (retain, nonatomic) UITabBarController* tabBarController;
@property (retain, nonatomic) NSString* richUrl;
@property (retain, nonatomic) NSString* passbookUrl;

@end
