//
//  PUPlacesService.m
//  partyUp
//
//  Created by Thiago Lioy on 9/8/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPlacesService.h"
#import "PUPlace.h"

@implementation PUPlacesService

-(void)fetchPlacesForQuery:(NSString*)query completion:(PlacesCompletion)completion{
    PFQuery *placeQuery = [PFQuery queryWithClassName:@"Place"];
    [placeQuery whereKey:@"canonicalName" containsString:[query uppercaseString]];
    [placeQuery orderByAscending:@"location"];
    placeQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
    placeQuery.maxCacheAge = 60 * 60 * 24;
    
    placeQuery.limit = _placesPerFetch;
    if(_skip && _skip > 0)
        placeQuery.skip = _skip;
    
    [placeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        
        NSArray *places = [PUPlace placesWithObjects:objects];
        completion(places,nil);
    }];
}

-(void)fetchPlacesNearMe:(PlacesCompletion)completion{
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        
            
        PFQuery *placeQuery = [PFQuery queryWithClassName:@"Place"];
        [placeQuery whereKey:@"location" nearGeoPoint:geoPoint];
        [placeQuery orderByAscending:@"location"];
        placeQuery.cachePolicy = kPFCachePolicyCacheElseNetwork;
        placeQuery.maxCacheAge = 60 * 60 * 24;
        
        placeQuery.limit = _placesPerFetch;
        if(_skip && _skip > 0)
            placeQuery.skip = _skip;
        
        [placeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if(error){
                completion(nil,error);
                return;
            }

            NSArray *places = [PUPlace placesWithObjects:objects];
            for(PUPlace *p in places)
                [p distanceInKmTo:geoPoint];
            completion(places,nil);
        }];
            
        
    }];
}
@end
