//
//  PUPartiesAndPlacesHelper.h
//  partyUp
//
//  Created by Thiago Lioy on 12/6/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUPartiesAndPlacesHelper : NSObject
+(NSArray*)splitPlacesSection:(NSArray*)places;
+(NSArray*)splitPartiesSection:(NSArray*)parties;
@end
