//
//  PUSearchSuggestionsService.m
//  partyUp
//
//  Created by Thiago Lioy on 9/16/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUSearchSuggestionsService.h"
#import "PUSearchSuggestion.h"

@implementation PUSearchSuggestionsService
-(void)fetchSuggestions:(SuggestionsCompletion)completion{
    PFQuery *query = [PFQuery queryWithClassName:@"SearchSuggestion"];
    query.cachePolicy = kPFCachePolicyCacheElseNetwork;
    query.maxCacheAge = 60 * 60 * 24;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(error){
            completion(nil,error);
            return;
        }
        NSArray *suggestions = [PUSearchSuggestion suggestionsWithParseObjects:objects];
        completion(suggestions,nil);
    }];
}
@end
