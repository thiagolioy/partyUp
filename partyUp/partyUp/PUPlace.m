//
//  PUPlace.m
//  partyUp
//
//  Created by Thiago Lioy on 8/28/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPlace.h"

@interface PUPlace()
@property(nonatomic,strong)PFGeoPoint *location;
@property(nonatomic,assign)double distanceInKm;
@end

@implementation PUPlace

+(instancetype)placeWithParseObj:(PFObject*)obj{
    PUPlace *place = [PUPlace new];
    place.placeId = [obj objectId];
    place.name =  obj[@"name"];
    place.placeDescription =  obj[@"description"];
    
    place.street =  obj[@"street"];
    place.number =  obj[@"number"];
    place.complement =  obj[@"complement"];
    
    place.neighborhood =  obj[@"neighborhood"];
    place.state =  obj[@"state"];
    place.city =  obj[@"city"];
    place.country =  obj[@"country"];
    place.location = obj[@"location"];
    return place;
}

+(NSArray*)placesWithObjects:(NSArray*)objects{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:objects.count];
    for(PFObject *o in objects)
        [array addObject:[PUPlace placeWithParseObj:o]];
    return  array;
}

-(void)distanceInKmTo:(PFGeoPoint*)point{
    _distanceInKm = [_location distanceInKilometersTo:point];
}
-(double)distanceInKm{
    return _distanceInKm;
}
-(NSString*)prettyFormattedAddress{
    NSString *prettyAddress = _street;
    if([_number isValid])
        prettyAddress = [NSString stringWithFormat:@"%@ %@",prettyAddress,_number];
    if([_complement isValid])
        prettyAddress = [NSString stringWithFormat:@"%@, %@",prettyAddress,_complement];
    
    return prettyAddress;
}
-(NSString*)prettyDistanceInKM{
    return [NSString stringWithFormat:@"%.2f km",_distanceInKm];
}
-(CLLocation*)location{
    return [[CLLocation alloc] initWithLatitude:_location.latitude longitude:_location.longitude];
}


@end
