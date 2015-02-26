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
#import "PUSocialService.h"
#import "PUBuddiesStorage.h"
#import <UIResponder+KeyboardCache.h>
#import "PUPushNotificationManager.h"

@interface PULoginViewController ()<UICollectionViewDataSource>
@property (strong, nonatomic) IBOutlet UIAsyncButton *loginButton;
@property(nonatomic,strong)IBOutlet UICollectionView *backgroundCollection;
@property(nonatomic,strong)IBOutlet UIPageControl *backgroundPageControl;


@property(nonatomic,strong)NSArray *contentMessages;
@property(nonatomic,strong)PUSocialService *service;
@end

@implementation PULoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSocialService];
    [self setUpContentMessages];
    [self setUpPageControl];
    [self checkIfUserAlreadyLoggedIn];
    [self hackToRemoveSearchKeyboardDelayOnFirstShow];
    [self trackPage];
}

-(void)trackPage{
    [[AnalyticsTriggerManager sharedManager] openScreen:@"/login"];
}


-(void)hackToRemoveSearchKeyboardDelayOnFirstShow{
    [UIResponder cacheKeyboard];
}

-(void)initSocialService{
    _service = [PUSocialService new];
}

-(void)setUpContentMessages{
    _contentMessages = @[@"Ache as melhores festas perto de você",
                         @"Coloque seu nome e de seus amigos na lista",
                        ];
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


-(void)checkIfUserAlreadyLoggedIn{
    if ([PFUser currentUser] &&
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self successOnLogin];
    }
}


- (IBAction)login:(id)sender {
    NSArray *permissions = @[@"public_profile",@"email",@"user_friends",@"publish_actions",@"rsvp_event",@"user_groups"];
    [PFFacebookUtils logInWithPermissions:permissions  block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
            [_loginButton reset];
            [PUAlertUtil showAlertWithMessage:@"Por favor, verifique suas permissões na conta do facebook."];
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
    if([PUBuddiesStorage myself] == nil)
        [self fetchMyself];
    else
        [self proceedToParties];
}

-(void)fetchMyself{
    [_service fetchMyself:^(PUUser *me, NSError *error) {
        [_loginButton reset];
        if(!error)
            [self proceedToParties];
    }];
}

-(void)proceedToParties{
   PUUser *myself = [PUBuddiesStorage myself];
   [PUPushNotificationManager linkUserOnCurrentInstallation:myself];
   [[AnalyticsTriggerManager sharedManager] login:myself];
   [self performSegueWithIdentifier:@"proceedToParties" sender:nil];
}
#pragma mark - CollectionView Methods
-(void)setUpPageControl{
    _backgroundPageControl.currentPage = 0;
    _backgroundPageControl.numberOfPages = _contentMessages.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _contentMessages.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"BackgroundCell";
    PULoginBackgroundCollectionViewCell *cell =  (PULoginBackgroundCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    NSString *contentMessage = [_contentMessages objectAtIndex:indexPath.row];
    cell.contentMessage.text = contentMessage;
    _backgroundPageControl.currentPage = indexPath.row;
    return  cell;
}
@end
