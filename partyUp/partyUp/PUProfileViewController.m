//
//  PUProfileViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUProfileViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "PUSocialService.h"

@interface PUProfileViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) PUSocialService *service;

@end

@implementation PUProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCircleMaskOnPicture];
    [self initSocialService];
    [self fetchUserInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title = @"Profile";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initSocialService{
    _service = [PUSocialService new];
}

-(void)setUpCircleMaskOnPicture{
    [_profilePicture roundIt:16.0f];
}

-(void)fetchUserInfo{
    [_service fetchMyself:^(PUUser *me, NSError *error) {
        if(!error)
            [self fillUserInfo:me];
        else
            [self recoverUserFromCache];
    }];
}

-(void)recoverUserFromCache{

}

-(void)fillUserInfo:(PUUser*)user{
    _profilePicture.profileID = user.userId;
    _profileName.text = user.name;
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    UIViewController *vc =  [self.parentViewController parentViewController];
    if([vc isKindOfClass:[UINavigationController class]])
        [((UINavigationController*)vc) popToRootViewControllerAnimated:YES];
}


@end
