//
//  AnalyticsTriggerManager.m
//  partyUp
//
//  Created by Thiago Lioy on 2/26/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "AnalyticsTriggerManager.h"
#import "GAService.h"
@interface AnalyticsTriggerManager()
@property(nonatomic,strong) GAService *gaTracker;
@end

@implementation AnalyticsTriggerManager

+ (AnalyticsTriggerManager *)sharedManager {
    static AnalyticsTriggerManager *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [AnalyticsTriggerManager new];
        [_sharedInstance setupService];
    });
    
    return _sharedInstance;
}

-(void)setupService{
    _gaTracker = [GAService new];
    _analyticsServices = @[_gaTracker];
    
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker setupService];
    }
}

-(void)openScreen:(NSString *) screenName{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker openScreen:screenName];
    }
}

-(void)logout{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker logout];
    }
}

-(void)login:(PUUser *) user{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker login:user];
    }
}

-(void)addFriendToEvent{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker addFriendToEvent];
    }
}

-(void)removeFriendFromEvent{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker removeFriendFromEvent];
    }
}

-(void)sendNamesEvent{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker sendNamesEvent];
    }
}

-(void)findOutRouteToEvent{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker findOutRouteToEvent];
    }
}

-(void)changePartyOrPlaceRadius:(int)radiusInKm{
    for(id<GenericTracker> generalTracker in _analyticsServices){
        [generalTracker changePartyOrPlaceRadius:radiusInKm];
    }
}

@end
