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
    NSDate *date = obj[@"date"];
    party.date =  [PUParty convertParseDate:date];
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
        prettyPrices = [NSString stringWithFormat:@"Masculino: %@",
                        [PUCurrencyUtil currencyWithValue:[_malePrice floatValue]]];
    if([_femalePrice isValid])
        prettyPrices = [NSString stringWithFormat:@"%@ | Feminino: %@",prettyPrices,
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
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm"];
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

+(NSDate *)convertParseDate:(NSDate *)sourceDate {
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSString *input = (NSString *)sourceDate;
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";
    // Always use this locale when parsing fixed format date strings
    NSLocale* posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.locale = posix;
    NSDate *convertedDate = [dateFormatter dateFromString:input];
    
    assert(convertedDate != nil);
    return convertedDate;
}

@end
