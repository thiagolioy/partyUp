//
//  NSCalendar+Convenience.h
//  partyUp
//
//  Created by Thiago Lioy on 8/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Convenience)
+(BOOL)isToday:(NSDate*)date;
+(BOOL)isThisWeek:(NSDate*)date;
+(BOOL)isNextWeek:(NSDate*)date;
+(NSDate*)today;
+(NSDate*)yesterday;
+(NSDate*)oneWeekFromNow;
+(int)daysFromDate:(NSDate*)firstDate toDate:(NSDate*)secondDate;
@end
