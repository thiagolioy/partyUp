//
//  PUSearchSuggestionsService.h
//  partyUp
//
//  Created by Thiago Lioy on 9/16/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SuggestionsCompletion)(NSArray *suggestions, NSError *error);
@interface PUSearchSuggestionsService : NSObject
-(void)fetchSuggestions:(SuggestionsCompletion)completion;
@end
