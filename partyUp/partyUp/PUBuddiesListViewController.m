//
//  PUBuddiesListViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/22/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBuddiesListViewController.h"
#import "PUBuddyTableViewCell.h"
#import "PUBestBuddyTableViewCell.h"
#import "PUHeaderTableViewCell.h"
#import "PUSocialService.h"

@interface PUBuddiesListViewController ()<UITableViewDataSource,UITableViewDelegate,PUBestBuddyTableViewCellDelegate,PUBuddyTableViewCellDelegate>
@property(nonatomic,strong)IBOutlet UITableView *buddiesTableView;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong)NSMutableArray *buddies;
@property(nonatomic,strong)NSMutableArray *bestBuddies;
@property(nonatomic,strong)PUSocialService *service;
@end

typedef NS_ENUM(NSUInteger, BuddiesSections) {
    bestBuddies,
    otherBuddies,
    numberOfSections
};

static NSString *buddiesCellID = @"BuddyCellID";
static NSString *bestBuddiesCellID = @"BestBuddyCellID";
static NSString *headerCellID = @"HeaderCellID";

@implementation PUBuddiesListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSocialService];
    [self fetchBuddies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSocialService{
    _service = [PUSocialService new];
}
-(void)initBuddiesArrays{
    if(!_buddies)
        _buddies = [NSMutableArray array];
    if(!_bestBuddies)
        _bestBuddies = [NSMutableArray array];
}

-(void)fetchBuddies{
    [self initBuddiesArrays];
    
    [_activityIndicator startAnimating];

    [_service fetchBuddies:^(NSArray *buddies, NSError *error) {
        [_activityIndicator stopAnimating];
        if(!error){
            [_buddies addObjectsFromArray:buddies];
            [_buddiesTableView reloadData];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == bestBuddies)
        return _bestBuddies.count;
    
    return _buddies.count;
}

-(PUUser*)buddyAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *buddies = [self buddiesForSection:indexPath.section];
    return [buddies objectAtIndex:indexPath.row];
}

-(NSArray*)buddiesForSection:(NSInteger)section{
    if(section == bestBuddies)
        return (NSArray*)_bestBuddies;
    
    return (NSArray*)_buddies;
}

- (PUBuddyTableViewCell *)tableView:(UITableView *)tableView buddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBuddyTableViewCell *cell = (PUBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:buddiesCellID];
   
    PUUser *buddy = [self buddyAtIndexPath:indexPath];
    [cell fill:buddy andDelegate:self];
    return cell;
}

- (PUBestBuddyTableViewCell *)tableView:(UITableView *)tableView bestBuddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBestBuddyTableViewCell *cell = (PUBestBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:bestBuddiesCellID];
    
    PUUser *buddy = [self buddyAtIndexPath:indexPath];
    [cell fill:buddy withDelegate:self];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == bestBuddies)
        return [self tableView:tableView bestBuddiesCellAtIndexPath:indexPath];
    else
        return [self tableView:tableView buddiesCellAtIndexPath:indexPath];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PUHeaderTableViewCell *cell = (PUHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
    if([self hasBestBuddies:section])
        cell.message.text = @"Best Buddies";
    else if([self hasBuddies:section])
        cell.message.text = @"Buddies";
    return [cell contentView];
}
-(BOOL)hasBestBuddies:(NSInteger)section{
    return (section == bestBuddies && _bestBuddies.count > 0);
}
-(BOOL)hasBuddies:(NSInteger)section{
    return (section == otherBuddies && _buddies.count > 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self hasBestBuddies:section])
        return 44.0f;
    else if([self hasBuddies:section])
        return 44.0f;
    return 0.0f;
}

#pragma mark - Cell Delegates
-(void)removeBuddy:(PUUser *)b{
    PUUser *buddy = [self findBuddy:b onList:_bestBuddies];
    if(buddy){
        [self demoteToBuddies:buddy];
        [_buddiesTableView reloadData];
    }
}


-(void)promoteToBestBuddies:(PUUser*)buddy{
    [_buddies removeObject:buddy];
    [_bestBuddies addObject:buddy];
}

-(void)demoteToBuddies:(PUUser*)buddy{
    [_bestBuddies removeObject:buddy];
    [_buddies addObject:buddy];
}

-(void)addToBestBuddies:(PUUser *)b{
    PUUser *buddy = [self findBuddy:b onList:_buddies];
    if(buddy){
        [self promoteToBestBuddies:buddy];
        [_buddiesTableView reloadData];
    }
}

-(PUUser*)findBuddy:(PUUser*)buddy onList:(NSArray*)buddies{
    for(PUUser *b in buddies)
        if([PUUser areTheSame:buddy otherUser:b])
            return b;
    return nil;
}


@end
