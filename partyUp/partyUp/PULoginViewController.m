//
//  PUViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/19/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PULoginViewController.h"
#import "PUPartiesViewController.h"
#import "PULoginBackgroundCollectionViewCell.h"

@interface PULoginViewController ()<UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property(nonatomic,strong)IBOutlet UICollectionView *backgroundCollection;
@property(nonatomic,strong)IBOutlet UIPageControl *backgroundPageControl;
@end

@implementation PULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkIfUserAlreadyLoggedIn];
    [self setUpPageControl];
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
        } else {
            NSLog(@"Some other error: %@", error);
        }
    }];
}

-(void)checkIfUserAlreadyLoggedIn{
    if ([PFUser currentUser] &&
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self successOnLogin];
    }
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
#pragma mark - CollectionView Methods
-(void)setUpPageControl{
    _backgroundPageControl.currentPage = 0;
    _backgroundPageControl.numberOfPages = 2;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"BackgroundCell";
    PULoginBackgroundCollectionViewCell *cell =  (PULoginBackgroundCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.backgroundImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"background-%d",(int)indexPath.row]];
    cell.titleMessage.text = @"Share";
    cell.contentMessage.text = @"Share great parties with your friends";
    _backgroundPageControl.currentPage = indexPath.row;
    return  cell;
}
@end
