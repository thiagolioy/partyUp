//
//  PUPlacesService.h
//  partyUp
//
//  Created by Thiago Lioy on 9/8/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PlacesCompletion)(NSArray *places, NSError *error);

@interface PUPlacesService : NSObject
@property(nonatomic,assign)NSInteger skip;
@property(nonatomic,assign)NSInteger placesPerFetch;

-(void)fetchPlacesNearMe:(PlacesCompletion)completion;
-(void)fetchPlacesForQuery:(NSString*)query completion:(PlacesCompletion)completion;
@end
