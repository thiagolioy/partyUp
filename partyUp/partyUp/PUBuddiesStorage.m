//
//  PUBuddiesStorage.m
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBuddiesStorage.h"
#import "PUUser.h"


static NSString *kStoredBuddies = @"storedBuddies";
@implementation PUBuddiesStorage

+(void)storeBuddies:(NSArray*)buddies{
    NSArray *array = [PUBuddiesStorage parseToDictionariesArray:buddies];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kStoredBuddies];
}

+(NSArray*)storedBuddies{
    NSArray *buddies = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredBuddies];
    return [PUBuddiesStorage parseToObjectsArray:buddies];
}


+(NSArray*)parseToObjectsArray:(NSArray*)array{
    NSMutableArray *buddies = [NSMutableArray arrayWithCapacity:array.count];
    for(NSDictionary *dc in array)
        [buddies addObject:[PUUser parseUser:dc]];
    return buddies;
}

+(NSArray*)parseToDictionariesArray:(NSArray*)array{
    NSMutableArray *buddies = [NSMutableArray arrayWithCapacity:array.count];
    for(PUUser *u in array)
        [buddies addObject:[u asDict]];
    return buddies;
}

@end
