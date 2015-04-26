//
//  UIView+roundMask.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "UIView+roundMask.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (roundMask)
-(void)roundIt:(CGFloat)randius{
    self.layer.cornerRadius = randius;
    self.clipsToBounds = YES;
}
@end
