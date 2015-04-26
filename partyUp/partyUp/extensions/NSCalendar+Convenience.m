//
//  NSCalendar+Convenience.m
//  partyUp
//
//  Created by Thiago Lioy on 8/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "NSCalendar+Convenience.h"

@implementation NSCalendar (Convenience)

+(BOOL)isToday:(NSDate*)date{
    NSDate *today = [NSDate date];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* todayCpms = [calendar components:unitFlags fromDate:today];
    NSDateComponents* dateCpms = [calendar components:unitFlags fromDate:date];
    
    return (
            [todayCpms day]   == [dateCpms day] &&
            [todayCpms month] == [dateCpms month] &&
            [todayCpms year]  == [dateCpms year]
            );
}

+(BOOL)isThisWeek:(NSDate*)date{
    NSDate *thisWeek = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitWeekOfYear;
    NSDateComponents* thisWeekCpms = [calendar components:unitFlags fromDate:thisWeek];
    NSDateComponents* dateCpms = [calendar components:unitFlags fromDate:date];
    
    return (
            [thisWeekCpms weekOfYear]   == [dateCpms weekOfYear]
            );
}

//+(NSDateComponents*)thisWeekCpms{
//    NSDate *thisWeek = [NSDate date];
//    NSCalendar* calendar = [NSCalendar currentCalendar];
//    unsigned unitFlags = NSCalendarUnitWeekOfYear;
//    return [calendar components:unitFlags fromDate:thisWeek];
//}

+(BOOL)isNextWeek:(NSDate*)date{
    NSDate *thisWeek = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSCalendarUnitWeekOfYear;
    NSDateComponents* thisWeekCpms = [calendar components:unitFlags fromDate:thisWeek];
    NSDateComponents* dateCpms = [calendar components:unitFlags fromDate:date];
    
    return (
            ([thisWeekCpms weekOfYear] + 1)   == [dateCpms weekOfYear]
            );
}

+(NSDate*)today{
    return [NSDate date];
}

+(NSDate*)yesterday{
    return [NSCalendar dateWithDaysDelta:-1];
}

+(NSDate*)oneWeekFromNow{
    return [NSCalendar dateWithDaysDelta:7];
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
