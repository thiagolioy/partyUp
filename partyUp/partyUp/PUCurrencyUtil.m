//
//  PUCurrencyUtil.m
//  partyUp
//
//  Created by Thiago Lioy on 3/1/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "PUCurrencyUtil.h"

@implementation PUCurrencyUtil

+(NSString *)currencyWithValue:(float)value{
    
    NSLocale *localeBR = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [numberFormatter setLocale:localeBR];
    NSNumber *number = [[NSNumber alloc] initWithFloat:value];
    
    NSString *fomatted = [numberFormatter stringFromNumber:number];
    
    return [fomatted stringByReplacingOccurrencesOfString:@"R$" withString:@"R$ "];
}

+(NSString *)currencySymbol{
    NSLocale *localeBR = [[NSLocale alloc] initWithLocaleIdentifier:@"pt_BR"];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setLocale:localeBR];
    
    return [formatter currencyCode];
}
@end
