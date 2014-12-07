//
//  PUProfileViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PUBuddiesStorage.h"
#import "PUBestBuddyTableViewCell.h"
#import "PUHeaderTableViewCell.h"
#import "PUBuddiesListViewController.h"

@interface PUProfileViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@end

@implementation PUProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCircleMaskOnPicture];
    [self recoverUserFromCache];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigationBarTitle];
}


-(void)setUpNavigationBarTitle{
    self.parentViewController.navigationItem.titleView = nil;
    self.parentViewController.navigationItem.title = @"Profile";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)setUpCircleMaskOnPicture{
    [_profilePicture roundIt:18.0f];
}


-(void)recoverUserFromCache{
    PUUser *me = [PUBuddiesStorage myself];
    if(me)
        [self fillUserInfo:me];
}

-(void)fillUserInfo:(PUUser*)user{
    _profilePicture.profileID = user.userId;
    _profileName.text = user.name;
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [PUBuddiesStorage clearStorage];
    UIViewController *vc =  [self.parentViewController parentViewController];
    if([vc isKindOfClass:[UINavigationController class]])
        [((UINavigationController*)vc) popToRootViewControllerAnimated:YES];
}

@end
