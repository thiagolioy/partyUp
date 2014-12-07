//
//  UIScrollView+PUReloadAnimations.m
//  partyUp
//
//  Created by Thiago Lioy on 12/7/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "UIScrollView+PUReloadAnimations.h"

@implementation UIScrollView (PUReloadAnimations)

-(void)triggerReloadAnimation{
    CATransition* swapAnimation = [CATransition animation];
    swapAnimation.type = kCATransitionFade;
    swapAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    swapAnimation.fillMode = kCAFillModeBoth;
    swapAnimation.duration = .6f;
    [self.layer addAnimation:swapAnimation forKey:@"UIScrollViewReloadDataAnimationKey"];
}
@end
