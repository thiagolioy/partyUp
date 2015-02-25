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
@property (strong, nonatomic) IBOutlet UILabel *radiusDistance;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UISlider *radiusSlider;
@end

@implementation PUProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCircleMaskOnPicture];
    [self setupRadiusSliderDefaultValue];
    [self recoverUserFromCache];
}

-(void)setupRadiusSliderDefaultValue{
    NSNumber *radiusDistance = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"radiusDistance"];
    if(!radiusDistance)
        radiusDistance = [NSNumber numberWithInt:30];
    [_radiusSlider setValue:[radiusDistance intValue] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigationBarTitle];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSNumber *distance = [NSNumber numberWithInt:[self radiusDistanceAsInt]];
    [[NSUserDefaults standardUserDefaults] setObject:distance forKey:@"radiusDistance"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATED_RADIUS_DISTANCE" object:nil];
}

-(int)radiusDistanceAsInt{
    return (int)_radiusSlider.value;
}

- (IBAction)changeRadiusDistance:(id)sender {
    _radiusDistance.text =  [NSString stringWithFormat:@"%d km",[self radiusDistanceAsInt]];
}


-(void)setUpNavigationBarTitle{
    self.parentViewController.navigationItem.titleView = nil;
    self.parentViewController.navigationItem.rightBarButtonItem = nil;
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
