//
//  PUProfileViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUProfileViewController.h"
#import <QuartzCore/QuartzCore.h>


@interface PUProfileViewController ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *profileName;

@end

@implementation PUProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCicleMaskOnPicture];
    [self fetchUserInfo];
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title = @"Profile";
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setUpCicleMaskOnPicture{
    [_profilePicture roundIt:40.0f];
}

-(void)fetchUserInfo{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            _profilePicture.profileID = [result objectForKey:@"id"];
            _profileName.text = [result objectForKey:@"name"];
        }
    }];
    

}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    UIViewController *vc =  [self.parentViewController parentViewController];
    if([vc isKindOfClass:[UINavigationController class]])
        [((UINavigationController*)vc) popToRootViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
