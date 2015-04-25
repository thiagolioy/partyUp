//
//  PUBuddiesStorage.m
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBuddiesStorage.h"

static NSString *kStoredBuddies = @"storedBuddies";
static NSString *kMyself = @"myself";
@implementation PUBuddiesStorage

+(void)storeMyself:(PUUser*)me{
    [[NSUserDefaults standardUserDefaults] setObject:[me asDict] forKey:kMyself];
}

+(void)storeBuddies:(NSArray*)buddies{
    NSArray *array = [PUBuddiesStorage parseToDictionariesArray:buddies];
    [[NSUserDefaults standardUserDefaults] setObject:array forKey:kStoredBuddies];
}

+(NSArray*)storedBuddies{
    NSArray *buddies = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredBuddies];
    return [PUBuddiesStorage parseToObjectsArray:buddies];
}
+(PUUser*)myself{
    NSDictionary *dc = [[NSUserDefaults standardUserDefaults] objectForKey:kMyself];
    PUUser *me = [PUUser parseUser:dc];
    return me.isEmpty ? nil : me;
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

+(NSString*)storedBuddiesAndMyselfAsMailBody{
    PUUser *myself = [PUBuddiesStorage myself];
    NSString *body = [NSString stringWithFormat:@"Lista de Nomes:\n%@",myself.name];
    NSArray *buddies = [PUBuddiesStorage storedBuddies];
    for(PUUser *b in buddies){
        body = [NSString stringWithFormat:@"%@\n%@",body,b.name];
    }
    return body;
}
+(void)clearStorage{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kMyself];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kStoredBuddies];
}

@end
