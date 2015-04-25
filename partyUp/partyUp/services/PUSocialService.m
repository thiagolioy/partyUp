//
//  PUSocialService.m
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUSocialService.h"
#import "PUBuddiesStorage.h"

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
            [PUBuddiesStorage storeMyself:me];
            completion(me,nil);
        }else
            completion(nil,error);
    }];
}



-(void)attendToEvent:(NSString*)eventId
            completion:(AttendToEventCompletion)completion{

    
    NSString *graphUrl = [NSString stringWithFormat:@"/%@/attending",eventId];
    [FBRequestConnection startWithGraphPath:graphUrl
                                 parameters:nil
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
                              completion(error);
                          }];
}

-(void)postOnEventFeed:(NSString*)eventId
               message:(NSString*)message
            completion:(PostOnEventFeedCompletion)completion{
    
    NSDictionary *params =@{@"message":message};
    NSString *graphUrl = [NSString stringWithFormat:@"/%@/feed",eventId];
    [FBRequestConnection startWithGraphPath:graphUrl
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,id result,NSError *error) {
                              NSString *fullId = [result objectForKey:@"id"];
                              NSArray *cpms = [fullId componentsSeparatedByString:@"_"];
                              NSString *eventId = cpms.firstObject;
                              NSString *postId = cpms.lastObject;
                              completion(eventId,postId,error);
                          }];
}
@end
