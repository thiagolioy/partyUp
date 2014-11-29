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

@interface PUBuddiesListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)IBOutlet UITableView *buddiesTableView;
@property(nonatomic,strong)NSMutableArray *buddies;
@property(nonatomic,strong)NSMutableArray *bestBuddies;
@end

typedef NS_ENUM(NSUInteger, BuddiesSections) {
    bestBuddies,
    otherBuddies,
    numberOfSections
};

static NSString *buddiesCellID = @"BuddyCellID";
static NSString *bestBuddiesCellID = @"BestBuddyCellID";
@implementation PUBuddiesListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchBuddies];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchBuddies{
    if(!_buddies)
        _buddies = [NSMutableArray array];
    if(!_bestBuddies)
        _bestBuddies = [NSMutableArray array];
    
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            for(NSDictionary *b in [result objectForKey:@"data"]){
                [_buddies addObject:b];
                [_buddies addObject:b];
                [_buddies addObject:b];
                [_bestBuddies addObject:b];
                [_bestBuddies addObject:b];

            }
        }
        _buddiesTableView.dataSource = self;
        _buddiesTableView.delegate = self;
        [_buddiesTableView reloadData];
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

-(NSArray*)buddiesForSection:(NSInteger)section{
    if(section == bestBuddies)
        return (NSArray*)_bestBuddies;
    
    return (NSArray*)_buddies;
}

- (PUBuddyTableViewCell *)tableView:(UITableView *)tableView buddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBuddyTableViewCell *cell = (PUBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:buddiesCellID];
    
    NSArray *buddies = [self buddiesForSection:indexPath.section];
    NSDictionary *dc = [buddies objectAtIndex:indexPath.row];
    [cell fill:dc];
    return cell;
}

- (PUBestBuddyTableViewCell *)tableView:(UITableView *)tableView bestBuddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBestBuddyTableViewCell *cell = (PUBestBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:bestBuddiesCellID];
    
    NSArray *buddies = [self buddiesForSection:indexPath.section];
    NSDictionary *dc = [buddies objectAtIndex:indexPath.row];
    [cell fill:dc];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == bestBuddies)
        return [self tableView:tableView bestBuddiesCellAtIndexPath:indexPath];
    else
        return [self tableView:tableView buddiesCellAtIndexPath:indexPath];
}

@end
