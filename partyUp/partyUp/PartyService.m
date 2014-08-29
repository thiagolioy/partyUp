//
//  PartyService.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PartyService.h"

@implementation PartyService

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
            
            [query whereKey:@"date" lessThan:[NSCalendar twoWeeksFromNow]];
            [query whereKey:@"date" greaterThan:[NSCalendar yesterday]];
            [query orderByAscending:@"date"];
            



//            [query selectKeys:@[@"name",@"promoImage",@"place"]];
            
            
            query.limit = _partiesPerFetch;
            if(_skip && _skip > 0)
                query.skip = _skip;
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    NSArray *parties = [PUParty partiesWithParseObjects:objects];
                    for(PUParty *p in parties)
                        [p.place distanceInKmTo:geoPoint];
                    completion(parties,nil);
                }else
                    completion(nil,error);
            }];
           
        }
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
