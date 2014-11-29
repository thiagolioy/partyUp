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

@interface PUProfileViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *profileName;
@property (strong, nonatomic) IBOutlet UITableView *bestBuddiesTableView;
@property (strong, nonatomic) NSArray *bestBuddies;

@end


static NSString *bestBuddiesCellID = @"BestBuddyCellID";
static NSString *headerCellID = @"HeaderCellID";

@implementation PUProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpCircleMaskOnPicture];
    [self recoverUserFromCache];
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title = @"Profile";
    [self recoverBuddiesFromCache];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)setUpCircleMaskOnPicture{
    [_profilePicture roundIt:16.0f];
}

-(void)recoverBuddiesFromCache{
    _bestBuddies = [PUBuddiesStorage storedBuddies];
    [_bestBuddiesTableView reloadData];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bestBuddies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PUBestBuddyTableViewCell *cell = (PUBestBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:bestBuddiesCellID];
    
    PUUser *buddy = [_bestBuddies objectAtIndex:indexPath.row];
    [cell fill:buddy];
    return cell;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PUHeaderTableViewCell *cell = (PUHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
    if([self hasBestBuddies:section])
        cell.message.text = @"Best Buddies";
    return [cell contentView];
}
-(BOOL)hasBestBuddies:(NSInteger)section{
    return  _bestBuddies.count > 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self hasBestBuddies:section])
        return 44.0f;
    return 0.0f;
}



@end
