//
//  PUSendMailHelper.h
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PUParty.h"
@interface PUSendMailHelper : NSObject
+(void)sendNamesTo:(PUParty*)party;
@end
