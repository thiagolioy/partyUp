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

@property(nonatomic,assign)NSInteger skip;
@property(nonatomic,assign)NSInteger partiesPerFetch;

-(void)fetchPartiesNearMe:(PartiesCompletion)completion;
-(void)fetchParty:(NSString*)partyId completion:(PartyCompletion)completion;

@end
