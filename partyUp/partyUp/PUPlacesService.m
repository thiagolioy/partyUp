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
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        
        PFQuery *queryName = [PFQuery queryWithClassName:@"Place"];
        [queryName whereKey:@"canonicalName" containsString:[query uppercaseString]];
        
        PFQuery *queryState = [PFQuery queryWithClassName:@"Place"];
        [queryState whereKey:@"canonicalCity" containsString:[query uppercaseString]];

        PFQuery *placeQuery = [PFQuery orQueryWithSubqueries:@[queryName,queryState]];
        [placeQuery orderByAscending:@"location"];
        
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

-(void)fetchPlacesNearMe:(PlacesCompletion)completion{
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
        [placeQuery orderByAscending:@"location"];
        placeQuery.limit = 20;
        
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
