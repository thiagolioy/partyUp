//
//  PartyService.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PartyService.h"

@implementation PartyService


-(NSDate*)yesterday{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = -1;
    NSDate *yesterday = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    return yesterday;

}

-(NSDate*)twoWeeksFromNow{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = 14;
    NSDate *twoWeeks = [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
    return twoWeeks;
}




-(void)fetchPartiesNearMe:(PartiesCompletion)completion{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            
            PFQuery *placeQuery = [PFQuery queryWithClassName:@"Place"];
            [placeQuery whereKey:@"location" nearGeoPoint:geoPoint];
            placeQuery.limit = 10;
            
            
            PFQuery *query = [PFQuery queryWithClassName:@"Party"];
//            query.cachePolicy = kPFCachePolicyNetworkElseCache;
//            query.maxCacheAge = 60 * 60 * 24;
            
            [query includeKey:@"place"];
            [query whereKey:@"place" matchesQuery:placeQuery];
            
            [query whereKey:@"date" lessThan:[self twoWeeksFromNow]];
            [query whereKey:@"date" greaterThan:[self yesterday]];
            [query orderByAscending:@"date"];
            



//            [query selectKeys:@[@"name",@"promoImage",@"place"]];
            
            
            query.limit = _partiesPerFetch;
            if(_skip && _skip > 0)
                query.skip = _skip;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    //Parseia
                    completion(objects,nil);
                }else
                    completion(nil,error);
            }];
           
        }
    }];
}

@end
