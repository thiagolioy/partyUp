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
    return @[
             [PUPartiesAndPlacesHelper sortPlacesByDistance:lessThan5km],
             [PUPartiesAndPlacesHelper sortPlacesByDistance:between5kmAnd20km],
             [PUPartiesAndPlacesHelper sortPlacesByDistance:moreThan20km]
             ];
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

    return @[
             [PUPartiesAndPlacesHelper sortPartiesByDistance:todays],
             [PUPartiesAndPlacesHelper sortPartiesByDistance:thisWeek],
             [PUPartiesAndPlacesHelper sortPartiesByDistance:nextWeek]
             ];
}

+(NSArray*)sortPlacesByDistance:(NSArray*)list{
    return [list sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        double d1 = [(PUPlace*)a distanceInKm];
        double d2 = [(PUPlace*)b distanceInKm];
        return d1 > d2;
    }];
}

+(NSArray*)sortPartiesByDistance:(NSArray*)list{
    return [list sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        double d1 = [[(PUParty*)a place] distanceInKm];
        double d2 = [[(PUParty*)b  place] distanceInKm];
        return d1 > d2;
    }];
}

@end
