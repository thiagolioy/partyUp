//
//  PUPlace.h
//  partyUp
//
//  Created by Thiago Lioy on 8/28/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUPlace : NSObject
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSString *placeId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *placeDescription;
@property(nonatomic,strong)NSString *street;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *complement;
@property(nonatomic,strong)NSString *neighborhood;
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *state;
@property(nonatomic,strong)NSString *country;

+(NSArray*)placesWithObjects:(NSArray*)objects;
+(instancetype)placeWithParseObj:(PFObject*)obj;
-(void)distanceInKmTo:(PFGeoPoint*)point;
-(double)distanceInKm;
-(CLLocation*)location;
-(NSString*)prettyFormattedAddress;
-(NSString*)prettyDistanceInKM;
@end
