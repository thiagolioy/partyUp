//
//  PUParty.m
//  partyUp
//
//  Created by Thiago Lioy on 8/28/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUParty.h"
@interface PUParty ()
@property(nonatomic,strong)NSString *sendNamesType;
@end

@implementation PUParty

+(instancetype)partyWithParseObj:(PFObject*)obj{
    PUParty *party = [PUParty new];
    party.partyId = [obj objectId];
    party.name =  obj[@"name"];
    
    PFFile *imageFile = (PFFile*)obj[@"image"];
    party.promoImage = imageFile.url;
    
    party.date =  obj[@"date"];
    party.partyDescription =  obj[@"description"];
    party.malePrice =  obj[@"malePrice"];
    party.femalePrice =  obj[@"femalePrice"];
    party.sendNamesType =  obj[@"sendNamesType"];
    party.sendNamesTo =  obj[@"sendNamesTo"];
    
    party.place = [PUPlace placeWithParseObj:obj[@"place"]];
    
    return party;
}
+(NSArray*)partiesWithParseObjects:(NSArray*)objects{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:objects.count];
    for(PFObject *o in objects)
        [array addObject:[PUParty partyWithParseObj:o]];
    return (NSArray*)array;
}

-(NSString*)prettyFormattedPrices{
    NSString *prettyPrices = @"";
    if([_malePrice isValid])
        prettyPrices = [NSString stringWithFormat:@"M: %@",
                        [PUCurrencyUtil currencyWithValue:[_malePrice floatValue]]];
    if([_femalePrice isValid])
        prettyPrices = [NSString stringWithFormat:@"%@  F: %@",prettyPrices,
                        [PUCurrencyUtil currencyWithValue:[_femalePrice floatValue]]];
    
    return prettyPrices;
}

-(NSString*)prettyFormattedDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy"];
    NSString *stringFromDate = [formatter stringFromDate:_date];
    return stringFromDate;
}

-(NSString*)prettyFormattedDatetime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd/MM/yyyy às hh:mm"];
    NSString *stringFromDate = [formatter stringFromDate:_date];
    return stringFromDate;
}

-(BOOL)isFacebookNamesList{
    return [_sendNamesType isEqualToString:@"facebook"];
}
-(BOOL)isMailNamesList{
    return [_sendNamesType isEqualToString:@"mail"];
}

-(NSString*)partyOrPlaceImageUrl{
    return  _promoImage != nil ? _promoImage : _place.image;
}

@end
