//
//  PUSearchSuggestion.h
//  partyUp
//
//  Created by Thiago Lioy on 9/16/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PUSearchSuggestion : NSObject
@property(nonatomic,strong)NSString *kind;
@property(nonatomic,strong)NSArray *suggestions;


-(BOOL)isPlaceKind;
-(BOOL)isCityKind;
-(BOOL)isFlavorKind;
+(instancetype)suggestionWithParseObj:(PFObject*)obj;
+(NSArray*)suggestionsWithParseObjects:(NSArray*)objects;

@end
