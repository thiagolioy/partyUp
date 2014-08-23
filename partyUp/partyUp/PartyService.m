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
            [placeQuery orderByAscending:@"location"];
            placeQuery.limit = 10;
            
            
            PFQuery *query = [PFQuery queryWithClassName:@"Party"];
            [query includeKey:@"place"];
            [query whereKey:@"place" matchesQuery:placeQuery];
            [query selectKeys:@[@"name",@"promoImage",@"place"]];
            
            
            query.limit = 10;
            
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
