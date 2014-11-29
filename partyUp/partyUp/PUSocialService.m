//
//  PUSocialService.m
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUSocialService.h"

@implementation PUSocialService

-(void)fetchBuddies:(BuddiesCompletion)completion{
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            NSMutableArray *buddies = [NSMutableArray array];
            for(NSDictionary *b in [result objectForKey:@"data"]){
                PUUser *u = [PUUser parseUser:b];
                [buddies addObject:u];
            }
            completion(buddies,nil);
        }else
            completion(nil,error);
    }];
}
-(void)fetchMyself:(MyselfCompletion)completion{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            PUUser *me = [PUUser parseUser:result];
            completion(me,nil);
        }else
            completion(nil,error);
    }];
}
@end
