//
//  PUPartiesAndPlacesHelper.m
//  partyUp
//
//  Created by Thiago Lioy on 12/6/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartiesAndPlacesHelper.h"
#import "PUParty.h"
#import "PUPlace.h"

@implementation PUPartiesAndPlacesHelper

+(NSArray*)splitPlacesSection:(NSArray*)places{
    NSMutableArray *lessThan5km = [NSMutableArray array];
    NSMutableArray *between5kmAnd20km = [NSMutableArray array];
    NSMutableArray *moreThan20km = [NSMutableArray array];
    for(PUPlace *p in places){
        if(p.distanceInKm < 5)
            [lessThan5km addObject:p];
        else if(p.distanceInKm > 5 && p.distanceInKm < 20)
            [between5kmAnd20km addObject:p];
        else
            [moreThan20km addObject:p];
    }
    return @[lessThan5km,between5kmAnd20km,moreThan20km];
}

+(NSArray*)splitPartiesSection:(NSArray*)parties{
    NSMutableArray *todays = [NSMutableArray array];
    NSMutableArray *thisWeek = [NSMutableArray array];
    NSMutableArray *nextWeek = [NSMutableArray array];
    for(PUParty *p in parties){
        if([NSCalendar isToday:p.date])
            [todays addObject:p];
        else if([NSCalendar isThisWeek:p.date])
            [thisWeek addObject:p];
        else
            [nextWeek addObject:p];
    }
    return @[todays,thisWeek,nextWeek];
}

@end
