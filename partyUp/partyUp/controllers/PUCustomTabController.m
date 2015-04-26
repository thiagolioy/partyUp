//
//  PUCustomTabController.m
//  partyUp
//
//  Created by Thiago Lioy on 10/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUCustomTabController.h"

@interface PUCustomTabController ()

@end

@implementation PUCustomTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customizeTabBarItems];
}

-(void)customizeTabBarItems{
    UIImage *partiesIcon = [UIImage imageNamed:@"partiesTabIconNormal"];
    UIImage *partiesIconSelected = [UIImage imageNamed:@"partiesTabIconSelected"];
    partiesIcon = [partiesIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    partiesIconSelected = [partiesIconSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *partiesItem = [self.tabBar.items firstObject];
    
    partiesItem.image = partiesIcon;
    partiesItem.selectedImage = partiesIconSelected;
    
    
    UIImage *profileIcon = [UIImage imageNamed:@"profileTabIconNormal"];
    UIImage *profileIconSelected = [UIImage imageNamed:@"profileTabIconSelected"];
    profileIcon = [profileIcon imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    profileIconSelected = [profileIconSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *profileItem = [self.tabBar.items lastObject];
    
    profileItem.image = profileIcon;
    profileItem.selectedImage = profileIconSelected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
