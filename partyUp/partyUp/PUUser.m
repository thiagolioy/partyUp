//
//  PUUser.m
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUUser.h"

@implementation PUUser
+(instancetype)parseUser:(NSDictionary*)dc{
    PUUser *user = [PUUser new];
    user.userId = [dc objectForKey:@"id"];
    user.name = [dc objectForKey:@"name"];
    return user;
}
+(BOOL)areTheSame:(PUUser*)user otherUser:(PUUser*)otherUser{
    return [user.userId isEqualToString:otherUser.userId];
}
-(NSDictionary*)asDict{
    return @{
             @"id":_userId,
             @"name":_name
             };
}
@end
