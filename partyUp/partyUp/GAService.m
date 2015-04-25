//
//  GAService.m
//  partyUp
//
//  Created by Thiago Lioy on 2/26/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "GAService.h"
#import <GoogleAnalytics-iOS-SDK/GAI.h>
#import <GoogleAnalytics-iOS-SDK/GAIDictionaryBuilder.h>
#import <GoogleAnalytics-iOS-SDK/GAIFields.h>
#import "PUEnvironmentUtil.h"


@interface GAService ()
@property(nonatomic,strong) id<GAITracker> tracker;
@end

@implementation GAService

-(void)setupService{
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:[PUEnvironmentUtil googleAnalyticsAppID]];
    
    _tracker = [[GAI sharedInstance] defaultTracker];
}

-(void)openScreen:(NSString *)screenName{
    [_tracker set:kGAIScreenName
           value:screenName];
    [_tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

-(void)logout{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                          action:@"button_press"  // Event action (required)
                                                           label:@"logout"          // Event label
                                                           value:nil] build]];
}


-(void)login:(PUUser *) user{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                           action:@"button_press"  // Event action (required)
                                                            label:@"login"          // Event label
                                                            value:nil] build]];
}


-(void)addFriendsToEvent{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                           action:@"button_press"  // Event action (required)
                                                            label:@"send_names_to_event"          // Event label
                                                            value:nil] build]];
}
-(void)addFriendToEvent{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                           action:@"button_press"  // Event action (required)
                                                            label:@"add_friend"          // Event label
                                                            value:nil] build]];
}

-(void)removeFriendFromEvent{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                           action:@"button_press"  // Event action (required)
                                                            label:@"remove_friend"          // Event label
                                                            value:nil] build]];
}

-(void)sendNamesEvent{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                           action:@"button_press"  // Event action (required)
                                                            label:@"send_names_to_event"          // Event label
                                                            value:nil] build]];
}

-(void)findOutRouteToEvent{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                           action:@"button_press"  // Event action (required)
                                                            label:@"route_to_event"          // Event label
                                                            value:nil] build]];
}

-(void)changePartyOrPlaceRadius:(int)radiusInKm{
    [_tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"ui_action"     // Event category (required)
                                                           action:@"slider_chnaged"  // Event action (required)
                                                            label:@"party_radius"          // Event label
                                                            value:[NSNumber numberWithInt:radiusInKm]] build]];
}


@end
