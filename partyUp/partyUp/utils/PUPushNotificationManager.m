//
//  PUPushNotificationManager.m
//  partyUp
//
//  Created by Thiago Lioy on 2/26/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "PUPushNotificationManager.h"
#import "PUBuddiesStorage.h"


@implementation PUPushNotificationManager

+(void)notifyFriend:(NSString*)friendID addedToEvent:(NSString*)eventName{
    
    PFQuery *pushQuery = [PFInstallation query];
    [pushQuery whereKey:@"user_id" equalTo:friendID];
    
    PUUser *myself = [PUBuddiesStorage myself];
    NSString *msg = [NSString stringWithFormat:@"%@ acabou de te adicionar na lista do evento %@",myself.name,eventName];
    
    
    PFPush *push = [[PFPush alloc] init];
    [push setQuery:pushQuery];
    [push setMessage:msg];
    [push sendPushInBackground];
}

+(void)subscribeToChannel:(NSString*)channel{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation addUniqueObject:channel forKey:@"channels"];
    [currentInstallation saveInBackground];
}

+(void)linkUserOnCurrentInstallation:(PUUser*)user{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    [currentInstallation setObject:user.userId forKey:@"user_id"];
    [currentInstallation setObject:user.name forKey:@"user_name"];
    [currentInstallation saveInBackground];
}

+(BOOL)handleParseNotificationPayload:(NSDictionary *)launchOptions{
    if(launchOptions){
        NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"handleParseNotificationPayload : %@" , notificationPayload);
        if(notificationPayload && notificationPayload.allKeys.count > 0){
            [PUPushNotificationManager handlePushOnParse:notificationPayload];
            return YES;
        }
    }
    return NO;
}

+(void)linkParseInstallationWithDeviceToken:(NSData*)deviceToken{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(!error){
            NSLog(@"linkParseInstallationWithDeviceToken : setting location");
            [currentInstallation setObject:geoPoint forKey:@"location"];
        }
        [currentInstallation saveInBackground];
    }];
}

+(void)trackOpenAppOnPush:(UIApplication *)application launchingOptions:(NSDictionary*)launchOptions{
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
        }
    }
}

+(void)trackOpenAppWithRemoteNotificationOnPush:(UIApplication *)application userInfo:(NSDictionary*)userInfo{
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

+(void)registerForNotifications:(UIApplication *)application{
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    
    [application registerForRemoteNotifications];
    [application registerUserNotificationSettings:settings];
}

+(void)handlePushOnParse:(NSDictionary*)userInfo{
    NSLog(@"handlePushOnParse : %@" , userInfo);
    [PFPush handlePush:userInfo];
}

@end
