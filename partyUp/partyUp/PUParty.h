//
//  PUParty.h
//  partyUp
//
//  Created by Thiago Lioy on 8/28/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUPlace.h"

@interface PUParty : NSObject
@property(nonatomic,strong)NSString *partyId;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *partyDescription;
@property(nonatomic,strong)NSString *promoImage;
@property(nonatomic,strong)PUPlace  *place;

+(instancetype)partyWithParseObj:(PFObject*)obj;
+(NSArray*)partiesWithParseObjects:(NSArray*)objects;


@end