//
//  PUAppDelegate.m
//  partyUp
//
//  Created by Thiago Lioy on 8/19/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUAppDelegate.h"

@implementation PUAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setUpParse:launchOptions];
    [self customizeAppearance];
    
    return YES;
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
-(void)setUpParse:(NSDictionary *)launchOptions{
    [Parse setApplicationId:@"5sjv0ulSUoP2jMeLfvblBcfWhAkhQ76bDwRVxnh6"
                  clientKey:@"UOctmS41hItgUkXn68cV84Oyp6f2uUH4Sqidkr2i"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    [PFFacebookUtils initializeFacebook];
}

-(void)customizeAppearance{
    [[UINavigationBar appearance] setBarTintColor: [UIColor blackColor]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    [[UITabBar appearance] setBarTintColor:[UIColor blackColor]];
}

@end
