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
@property (assign, nonatomic) int radiusInitialValue;
@end

@implementation PUProfileViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCircleMaskOnPicture];
    [self setupRadiusSliderDefaultValue];
    [self recoverUserFromCache];
    [self trackPage];
}

-(void)trackPage{
    [[AnalyticsTriggerManager sharedManager] openScreen:@"/profile"];
}

-(void)setupRadiusSliderDefaultValue{
    NSNumber *radiusDistance = (NSNumber*)[[NSUserDefaults standardUserDefaults] objectForKey:@"radiusDistance"];
    if(!radiusDistance)
        radiusDistance = [NSNumber numberWithInt:30];
    _radiusInitialValue = [radiusDistance intValue];
    [_radiusSlider setValue:[radiusDistance intValue] animated:YES];
    [self setDistanceLabelValue:[self radiusDistanceAsInt]];
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUpNavigationBarTitle];
}

-(void)viewWillDisappear:(BOOL)animated{
    NSNumber *distance = [NSNumber numberWithInt:[self radiusDistanceAsInt]];
    if([self didChangeRadius])
        [[AnalyticsTriggerManager sharedManager] changePartyOrPlaceRadius:[distance intValue]];
    
    [[NSUserDefaults standardUserDefaults] setObject:distance forKey:@"radiusDistance"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UPDATED_RADIUS_DISTANCE" object:nil];
}

-(BOOL)didChangeRadius{
    return _radiusInitialValue != [self radiusDistanceAsInt];
}

-(int)radiusDistanceAsInt{
    return (int)_radiusSlider.value;
}

- (IBAction)changeRadiusDistance:(id)sender {
    [self setDistanceLabelValue:[self radiusDistanceAsInt]];
}

-(void)setDistanceLabelValue:(int)distance{
    _radiusDistance.text =  [NSString stringWithFormat:@"%d km",distance];
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
    [[AnalyticsTriggerManager sharedManager] logout];
    [PFUser logOut];
    [PUBuddiesStorage clearStorage];
    UIViewController *vc =  [self.parentViewController parentViewController];
    if([vc isKindOfClass:[UINavigationController class]])
        [((UINavigationController*)vc) popToRootViewControllerAnimated:YES];
}

@end
