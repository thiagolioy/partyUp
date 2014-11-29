//
//  PUBuddiesStorage.h
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUUser.h"

@interface PUBuddiesStorage : NSObject

+(void)storeMyself:(PUUser*)me;
+(PUUser*)myself;
+(void)storeBuddies:(NSArray*)buddies;
+(NSArray*)storedBuddies;
+(NSString*)storedBuddiesAndMyselfAsMailBody;
+(void)clearStorage;
@end
