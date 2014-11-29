//
//  PUSocialService.h
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUUser.h"

typedef void (^MyselfCompletion)(PUUser *me, NSError *error);
typedef void (^BuddiesCompletion)(NSArray *buddies, NSError *error);

@interface PUSocialService : NSObject

-(void)fetchBuddies:(BuddiesCompletion)completion;
-(void)fetchMyself:(MyselfCompletion)completion;

@end
