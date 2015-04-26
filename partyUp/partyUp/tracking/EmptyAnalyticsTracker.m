//
//  EmptyAnalyticsTracker.m
//  partyUp
//
//  Created by Thiago Lioy on 2/26/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "EmptyAnalyticsTracker.h"

@implementation EmptyAnalyticsTracker
-(void)setupService{}
-(void)openScreen:(NSString *) screenName{}
-(void)logout{}
-(void)login:(PUUser *) user{}
-(void)addFriendToEvent{}
-(void)removeFriendFromEvent{}
-(void)sendNamesEvent{}
-(void)findOutRouteToEvent{}
-(void)changePartyOrPlaceRadius:(int)radiusInKm{}
@end
