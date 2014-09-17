//
//  PUSearchSuggestion.m
//  partyUp
//
//  Created by Thiago Lioy on 9/16/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUSearchSuggestion.h"

@implementation PUSearchSuggestion


-(BOOL)isPlaceKind{
    return [_kind isEqualToString:@"place"];
}
-(BOOL)isCityKind{
    return [_kind isEqualToString:@"city"];
}
-(BOOL)isFlavorKind{
    return [_kind isEqualToString:@"flavor"];
}
+(instancetype)suggestionWithParseObj:(PFObject*)obj{
    PUSearchSuggestion *suggestion = [PUSearchSuggestion new];
    suggestion.kind =  obj[@"kind"];
    suggestion.suggestions =  obj[@"suggestions"];
    return suggestion;
}
+(NSArray*)suggestionsWithParseObjects:(NSArray*)objects{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:objects.count];
    for(PFObject *o in objects)
        [array addObject:[PUSearchSuggestion suggestionWithParseObj:o]];
    return (NSArray*)array;
}

@end
