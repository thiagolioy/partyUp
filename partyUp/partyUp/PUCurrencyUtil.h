//
//  PUCurrencyUtil.h
//  partyUp
//
//  Created by Thiago Lioy on 3/1/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PUCurrencyUtil : NSObject

+(NSString *)currencyWithValue:(float)value;
+(NSString *)currencySymbol;
@end
