//
//  PUParty.m
//  partyUp
//
//  Created by Thiago Lioy on 8/28/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUParty.h"

@implementation PUParty

+(instancetype)partyWithParseObj:(PFObject*)obj{
    PUParty *party = [PUParty new];
    party.partyId = [obj objectId];
    party.name =  obj[@"name"];
    party.promoImage =  obj[@"promoImage"];
    
    party.place = [PUPlace placeWithParseObj:obj[@"place"]];
    
    return party;
}
+(NSArray*)partiesWithParseObjects:(NSArray*)objects{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:objects.count];
    for(PFObject *o in objects)
        [array addObject:[PUParty partyWithParseObj:o]];
    return (NSArray*)array;
}

@end
