//
//  PUSendMailHelper.m
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUSendMailHelper.h"
#import "PUBuddiesStorage.h"

static NSString *mailRecipe = @"mailto:%@?subject=%@&body=%@";
@implementation PUSendMailHelper
+(void)sendNamesTo:(PUParty*)party{
    
    NSString *subject = [NSString stringWithFormat:@"%@ : lista de nomes",party.name];
    NSString *body = [PUBuddiesStorage storedBuddiesAsMailBody];
    NSString *message = [NSString stringWithFormat:mailRecipe,party.sendNamesTo,subject,body];
    
    message = [message stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:message]];
}


@end
