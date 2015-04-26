//
//  PUEnvironmentUtil.m
//  partyUp
//
//  Created by Thiago Lioy on 4/22/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "PUEnvironmentUtil.h"
#import <DBEnvironmentConfiguration/DBEnvironmentConfiguration.h>

@implementation PUEnvironmentUtil

+(void)setupEnvironmentMappings{
    [DBEnvironmentConfiguration setEnvironmentMapping:@{
                                                        [NSNumber numberWithInt:DBBuildTypeSimulator]     : @"Staging",
                                                        [NSNumber numberWithInt:DBBuildTypeDebug]         : @"Staging",
                                                        [NSNumber numberWithInt:DBBuildTypeAdHoc]         : @"Staging",
                                                        [NSNumber numberWithInt:DBBuildTypeAppStore]      : @"Production",
                                                        [NSNumber numberWithInt:DBBuildTypeEnterprise]    : @"Production"
                                                        }];
}


+(NSString*)googleAnalyticsAppID{
    return  [DBEnvironmentConfiguration valueForKey:@"google_analytics_app_id"];
}

+(NSString*)parseAppID{
    return  [DBEnvironmentConfiguration valueForKey:@"parse_app_id"];
}

+(NSString*)parseClientKey{
    return  [DBEnvironmentConfiguration valueForKey:@"parse_client_key"];
}

@end
