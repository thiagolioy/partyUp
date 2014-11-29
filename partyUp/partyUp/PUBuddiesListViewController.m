//
//  PUBuddiesListViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/22/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBuddiesListViewController.h"
#import "PUBuddyTableViewCell.h"

@interface PUBuddiesListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)IBOutlet UITableView *buddiesTableView;
@property(nonatomic,strong)NSMutableArray *buddies;
@end

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
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if(!error){
            for(NSDictionary *b in [result objectForKey:@"data"]){
                [_buddies addObject:b];
                [_buddies addObject:b];
                [_buddies addObject:b];
                [_buddies addObject:b];
                [_buddies addObject:b];

            }
        }
        _buddiesTableView.dataSource = self;
        _buddiesTableView.delegate = self;
        [_buddiesTableView reloadData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _buddies.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"BuddyCellID";
    PUBuddyTableViewCell *cell = (PUBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *dc = [_buddies objectAtIndex:indexPath.row];
    [cell fill:dc];
    return cell;
}

@end
