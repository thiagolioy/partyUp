//
//  NSString+Validators.m
//  partyUp
//
//  Created by Thiago Lioy on 10/26/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "NSString+Validators.h"

@implementation NSString (Validators)
-(BOOL)isValid{
    return self && ![self isEqualToString:@""];
}
@end
