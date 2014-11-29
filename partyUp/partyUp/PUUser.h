//
//  PUUser.h
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUUser : NSObject
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *name;

+(instancetype)parseUser:(NSDictionary*)dc;
+(BOOL)areTheSame:(PUUser*)user otherUser:(PUUser*)otherUser;
-(NSDictionary*)asDict;
@end
