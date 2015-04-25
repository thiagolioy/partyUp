//
//  PUEnvironmentUtil.h
//  partyUp
//
//  Created by Thiago Lioy on 4/22/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUEnvironmentUtil : NSObject
+(void)setupEnvironmentMappings;
+(NSString*)googleAnalyticsAppID;
+(NSString*)parseAppID;
+(NSString*)parseClientKey;
@end
