//
//  PUPushNotificationManager.h
//  partyUp
//
//  Created by Thiago Lioy on 2/26/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUPushNotificationManager : NSObject

+(void)subscribeToChannel:(NSString*)channel;
+(BOOL)handleParseNotificationPayload:(NSDictionary *)launchOptions;
+(void)linkParseInstallationWithDeviceToken:(NSData*)deviceToken;
+(void)trackOpenAppOnPush:(UIApplication *)application launchingOptions:(NSDictionary*)launchOptions;
+(void)trackOpenAppWithRemoteNotificationOnPush:(UIApplication *)application userInfo:(NSDictionary*)userInfo;
+(void)registerForNotifications:(UIApplication *)application;
+(void)handlePushOnParse:(NSDictionary*)userInfo;

@end
