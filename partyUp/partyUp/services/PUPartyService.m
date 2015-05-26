 //
//  PartyService.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyService.h"

@implementation PUPartyService

-(void)fetchPartiesForQuery:(NSString*)queryText completion:(PartiesCompletion)completion{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Party"];
        [query whereKey:@"canonicalName" containsString:[queryText uppercaseString]];
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        query.maxCacheAge = 60 * 60 * 24;
        [query includeKey:@"place"];
        [query whereKey:@"date" lessThan:[NSCalendar oneWeekFromNow]];
        [query whereKey:@"date" greaterThanOrEqualTo:[NSCalendar today]];
        [query orderByAscending:@"date"];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error){
                completion(nil,error);
                return;
            }
            
            NSArray *parties = [PUParty partiesWithParseObjects:objects];
            for(PUParty *p in parties)
                [p.place distanceInKmTo:geoPoint];
            completion(parties,nil);
        }];
        
    }];
}


-(void)fetchPartiesForPlace:(PUPlace*)place completion:(PartiesCompletion)completion{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        
        PFQuery *placeQuery = [PFQuery queryWithClassName:@"Place"];
        [placeQuery whereKey:@"objectId" equalTo:place.placeId];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Party"];
        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
        query.maxCacheAge = 60 * 60 * 24;
        [query includeKey:@"place"];
        [query whereKey:@"place" matchesQuery:placeQuery];
        
        [query whereKey:@"date" lessThan:[NSCalendar oneWeekFromNow]];
        [query whereKey:@"date" greaterThan:[NSCalendar yesterday]];
        [query orderByAscending:@"date"];
        query.limit = 10;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error){
                completion(nil,error);
                return;
            }
            
            NSArray *parties = [PUParty partiesWithParseObjects:objects];
            for(PUParty *p in parties)
                [p.place distanceInKmTo:geoPoint];
            completion(parties,nil);
        }];
        
    }];
}
-(void)fetchPartiesNearMe:(PartiesCompletion)completion{
    NSNumber *radiusDistance = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"radiusDistance"];
    if(!radiusDistance)
        radiusDistance = [NSNumber numberWithInt:30];
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        
        PFQuery *placeQuery = [PFQuery queryWithClassName:@"Place"];
        [placeQuery whereKey:@"location" nearGeoPoint:geoPoint withinKilometers:[radiusDistance intValue]];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Party"];
        [query includeKey:@"place"];
        [query whereKey:@"date" lessThan:[NSCalendar oneWeekFromNow]];
        [query whereKey:@"date" greaterThan:[NSCalendar yesterday]];
        [query whereKey:@"place" matchesQuery:placeQuery];
        [query orderByAscending:@"date"];
        query.limit = 10;
        
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error){
                completion(nil,error);
                return;
            }
            
            NSArray *parties = [PUParty partiesWithParseObjects:objects];
            for(PUParty *p in parties)
                [p.place distanceInKmTo:geoPoint];
            completion(parties,nil);
        }];
    
    }];
}
@end
