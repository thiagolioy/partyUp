//
//  PUViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/19/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PULoginViewController.h"
#import <Parse/Parse.h>
#import "PUPartiesViewController.h"

@interface PULoginViewController ()
@property (strong, nonatomic) IBOutlet UIView *checkingUserLoggedInView;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation PULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self checkIfUserAlreadyLoggedIn];
  
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        _loginButton.hidden = YES;
        _logoutButton.hidden = NO;
         NSLog(@"User Already logged In");
        [self successOnLogin];
    }else{

        _loginButton.hidden = NO;
        _logoutButton.hidden = YES;
    }
    _checkingUserLoggedInView.hidden = YES;
}


- (IBAction)login:(id)sender {
    NSArray *permissions = @[@"public_profile",@"email",@"user_friends"];
    [PFFacebookUtils logInWithPermissions:permissions  block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else {
            if (user.isNew) {
                NSLog(@"User signed up and logged in through Facebook!");
            } else {
                NSLog(@"User logged in through Facebook!");
            }
            [self successOnLogin];
        }
    }];
}

-(void)successOnLogin{
    [self performSegueWithIdentifier:@"proceedToParties" sender:nil];
}

- (IBAction)logout:(id)sender {
     [PFUser logOut];
    NSLog(@"User logout");
    _loginButton.hidden = NO;
    _logoutButton.hidden = YES;

}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"proceedToParties"]){
        PUPartiesViewController *dest = (PUPartiesViewController*)[segue destinationViewController];
        //set data on destination if needed
        return;
    }
    
}

@end
