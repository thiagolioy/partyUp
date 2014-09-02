//
//  NSCalendar+Convenience.h
//  partyUp
//
//  Created by Thiago Lioy on 8/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Convenience)
+(NSDate*)today;
+(NSDate*)yesterday;
+(NSDate*)twoWeeksFromNow;
+(int)daysFromDate:(NSDate*)firstDate toDate:(NSDate*)secondDate;
@end
