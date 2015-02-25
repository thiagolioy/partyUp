//
//  PUAppDelegate.m
//  partyUp
//
//  Created by Thiago Lioy on 8/19/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUAppDelegate.h"
#import "PUCustomApperance.h"

@implementation PUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpParse:launchOptions forApplication:application];
    [self registerForNotifications:application];
    [self trackOpenAppOnPush:application launchingOptions:launchOptions];
    [self handleParseNotificationPayload:launchOptions];
    [self customizeAppearance];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self linkParseInstallationWithDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self trackOpenAppWithRemoteNotificationOnPush:application userInfo:userInfo];
    [self handlePushOnParse:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}


#pragma mark - Configuration Methods
-(void)setUpParse:(NSDictionary *)launchOptions forApplication:(UIApplication *)application{
    [Parse setApplicationId:@"5sjv0ulSUoP2jMeLfvblBcfWhAkhQ76bDwRVxnh6"
                  clientKey:@"UOctmS41hItgUkXn68cV84Oyp6f2uUH4Sqidkr2i"];
    [PFFacebookUtils initializeFacebook];
}

-(void)customizeAppearance{
    [PUCustomApperance customizeNavBar];
    [PUCustomApperance customizeTabBar];
    [PUCustomApperance customizeSearchBar];
}

-(BOOL)handleParseNotificationPayload:(NSDictionary *)launchOptions{
    if(launchOptions){
        NSDictionary *notificationPayload = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        NSLog(@"handleParseNotificationPayload : %@" , notificationPayload);
        if(notificationPayload && notificationPayload.allKeys.count > 0){
            [self handlePushOnParse:notificationPayload];
            return YES;
        }
    }
    return NO;
}

-(void)linkParseInstallationWithDeviceToken:(NSData*)deviceToken{
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

-(void)trackOpenAppOnPush:(UIApplication *)application launchingOptions:(NSDictionary*)launchOptions{
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

-(void)trackOpenAppWithRemoteNotificationOnPush:(UIApplication *)application userInfo:(NSDictionary*)userInfo{
    if (application.applicationState == UIApplicationStateInactive) {
        // The application was just brought from the background to the foreground,
        // so we consider the app as having been "opened by a push notification."
        [PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo];
    }
}

-(void)registerForNotifications:(UIApplication *)application{
    
    UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                    UIUserNotificationTypeBadge |
                                                    UIUserNotificationTypeSound);
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                             categories:nil];
    
    [application registerForRemoteNotifications];
    [application registerUserNotificationSettings:settings];
}

-(void)handlePushOnParse:(NSDictionary*)userInfo{
    NSLog(@"handlePushOnParse : %@" , userInfo);
    [PFPush handlePush:userInfo];
}

@end
