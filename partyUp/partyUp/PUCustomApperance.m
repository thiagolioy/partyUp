//
//  PUCustomApperance.m
//  partyUp
//
//  Created by Thiago Lioy on 10/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUCustomApperance.h"

#define NAV_TAB_BG [UIColor colorWithPatternImage:[UIImage imageNamed:@"navTabBg"]]
#define DARK_GRAY [UIColor colorWithRed:38.0f/255.0f green:50.0f/255.0f blue:56.0f/255.0f alpha:1]
#define LIGHT_GRAY [UIColor colorWithRed:236.0f/255.0f green:239.0f/255.0f blue:241.0f/255.0f alpha:1]

@implementation PUCustomApperance

+(void)customizeNavBar{
    [[UINavigationBar appearance] setBarTintColor: NAV_TAB_BG];
    [[UINavigationBar appearance] setTintColor:DARK_GRAY];
    
    
    NSDictionary *props = @{NSForegroundColorAttributeName : DARK_GRAY
                            };
    [[UINavigationBar appearance] setTitleTextAttributes:props];
}
+(void)customizeTabBar{
    
    [[UITabBar appearance] setBarTintColor:NAV_TAB_BG];
    [[UITabBar appearance] setTintColor:DARK_GRAY];
    
    NSDictionary *props = @{NSForegroundColorAttributeName : DARK_GRAY
                            };
    [[UITabBarItem appearance] setTitleTextAttributes:props
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:props
                                             forState:UIControlStateNormal];


}

+(void)customizeSearchBar{
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil]
     setTextColor:LIGHT_GRAY];
}
@end
