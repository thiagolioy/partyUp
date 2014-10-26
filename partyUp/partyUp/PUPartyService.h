//
//  PartyService.h
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUParty.h"

typedef void (^PartiesCompletion)(NSArray *parties, NSError *error);
typedef void (^PartyCompletion)(PUParty *party, NSError *error);

@interface PUPartyService : NSObject


-(void)fetchPartiesForPlace:(PUPlace*)place completion:(PartiesCompletion)completion;
-(void)fetchPartiesNearMe:(PartiesCompletion)completion;

@end
