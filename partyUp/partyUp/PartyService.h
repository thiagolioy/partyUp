//
//  PartyService.h
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^PartiesCompletion)(NSArray *parties, NSError *error);

@interface PartyService : NSObject
-(void)fetchPartiesNearMe:(PartiesCompletion)completion;
@end
