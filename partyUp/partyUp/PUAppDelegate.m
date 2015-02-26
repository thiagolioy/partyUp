//
//  PUAppDelegate.m
//  partyUp
//
//  Created by Thiago Lioy on 8/19/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUAppDelegate.h"
#import "PUCustomApperance.h"
#import "PUPushNotificationManager.h"

@implementation PUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpParse:launchOptions forApplication:application];
    [PUPushNotificationManager registerForNotifications:application];
    [PUPushNotificationManager trackOpenAppOnPush:application launchingOptions:launchOptions];
    [PUPushNotificationManager handleParseNotificationPayload:launchOptions];
    [[AnalyticsTriggerManager sharedManager] setupService];
    [self customizeAppearance];
    
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [PUPushNotificationManager linkParseInstallationWithDeviceToken:deviceToken];
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PUPushNotificationManager trackOpenAppWithRemoteNotificationOnPush:application userInfo:userInfo];
    [PUPushNotificationManager handlePushOnParse:userInfo];
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

@end
