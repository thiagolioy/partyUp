//
//  PUBuddiesStorage.h
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUBuddiesStorage : NSObject

+(void)storeBuddies:(NSArray*)buddies;
+(NSArray*)storedBuddies;

@end
