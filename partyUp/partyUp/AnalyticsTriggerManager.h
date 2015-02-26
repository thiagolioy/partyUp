//
//  AnalyticsTriggerManager.h
//  partyUp
//
//  Created by Thiago Lioy on 2/26/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EmptyAnalyticsTracker.h"

@interface AnalyticsTriggerManager : NSObject<GenericTracker>
@property(nonatomic,strong,readonly)NSArray *analyticsServices;
+ (AnalyticsTriggerManager *)sharedManager;
@end
