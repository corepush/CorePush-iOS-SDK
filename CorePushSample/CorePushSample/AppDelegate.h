//
//  AppDelegate.h
//  CorePushSample
//
//  Copyright (c) 2012 株式会社ブレスサービス. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    NSMutableData* receivedData_;
}

@property (retain, nonatomic) UIWindow *window;

@property (retain, nonatomic) ViewController *viewController;

@property (retain, nonatomic) NSMutableData* receivedData;

- (NSData*) createPostDate:(NSDictionary *)dict;
- (void)sendDeviceTokenToServer:(NSString*)deviceToken;
- (void)removeDeviceTokenToServer:(NSString*)deviceToken;

@end
