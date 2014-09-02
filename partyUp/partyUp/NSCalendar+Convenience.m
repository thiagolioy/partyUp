//
//  NSCalendar+Convenience.m
//  partyUp
//
//  Created by Thiago Lioy on 8/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "NSCalendar+Convenience.h"

@implementation NSCalendar (Convenience)

+(NSDate*)today{
    return [NSDate date];
}

+(NSDate*)yesterday{
    return [NSCalendar dateWithDaysDelta:1];
}

+(NSDate*)twoWeeksFromNow{
    return [NSCalendar dateWithDaysDelta:14];
}

+(NSDate*)dateWithDaysDelta:(NSInteger)delta{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [NSDateComponents new];
    comps.day = delta;
    return [calendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
}

+(int)daysFromDate:(NSDate*)firstDate toDate:(NSDate*)secondDate{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSDayCalendarUnit fromDate:firstDate toDate:secondDate options:0];
    return comps.day;
}

@end
