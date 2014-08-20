//
//  PUViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/19/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUViewController.h"
#import <Parse/Parse.h>

@interface PUViewController ()

@end

@implementation PUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self checkIfUserAlreadyLoggedIn];
  
    
}

-(void)oAuthExceptionHandler{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            
        } else if ([error.userInfo[FBErrorParsedJSONResponseKey][@"body"][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The facebook session was invalidated");
            [self logout:nil];
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

-(void)checkIfUserAlreadyLoggedIn{
    if ([PFUser currentUser] &&
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {

         NSLog(@"User Already logged In");
    }
}

- (IBAction)login:(id)sender {
    NSArray *permissions = @[@"public_profile",@"email",@"user_friends"];
    [PFFacebookUtils logInWithPermissions:permissions  block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
    }];
}
- (IBAction)logout:(id)sender {
     [PFUser logOut];
    NSLog(@"User logout");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
