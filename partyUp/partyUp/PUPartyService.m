//
//  PartyService.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyService.h"

@implementation PUPartyService

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
        
        
        
        query.limit = _partiesPerFetch;
        if(_skip && _skip >= 0)
            query.skip = _skip;
        
        
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
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        
        PFQuery *placeQuery = [PFQuery queryWithClassName:@"Place"];
        [placeQuery whereKey:@"location" nearGeoPoint:geoPoint];
//        placeQuery.limit = 10;
        
        
        PFQuery *query = [PFQuery queryWithClassName:@"Party"];
//        query.cachePolicy = kPFCachePolicyCacheElseNetwork;
//        query.maxCacheAge = 60 * 60 * 24;
        
        [query includeKey:@"place"];
        [query whereKey:@"place" matchesQuery:placeQuery];
        
        [query whereKey:@"date" lessThan:[NSCalendar oneWeekFromNow]];
        [query whereKey:@"date" greaterThan:[NSCalendar yesterday]];
        [query orderByAscending:@"date"];
        

        if(_partiesPerFetch)
            query.limit = _partiesPerFetch;
        if(_skip && _skip >= 0)
            query.skip = _skip;
        
        
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

-(void)fetchParty:(NSString*)partyId completion:(PartyCompletion)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"Party"];
    [query includeKey:@"place"];
    [query getObjectInBackgroundWithId:partyId block:^(PFObject *obj, NSError *error) {
        if(error){
            completion(nil,error);
            return ;
        }
        
        PUParty *party = [PUParty partyWithParseObj:obj];
        completion(party,nil);
    }];
}

@end
