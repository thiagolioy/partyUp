//
//  PUPartiesViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartiesViewController.h"
#import <Parse/Parse.h>

@interface PUPartiesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *partiesTableView;
@property(nonatomic,strong)NSArray *parties;
@end

static NSString *cellID = @"partyCellID";

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hidesNavigationBackButton];
    [self fetchParties];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title = @"Parties";
}

-(void)hidesNavigationBackButton{
    self.parentViewController.navigationItem.hidesBackButton = YES;
}

-(void)fetchParties{
    PFQuery *query = [PFQuery queryWithClassName:@"Party"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error){
            NSMutableArray *partiesArray = [NSMutableArray arrayWithCapacity:objects.count];
            for(PFObject *o in objects){
                NSString *name =  o[@"name"];
                [partiesArray addObject:@{@"name":name}];
            }
            _parties = (NSArray*)[partiesArray copy];
            
            _partiesTableView.dataSource = self;
            _partiesTableView.delegate = self;
            [_partiesTableView reloadData];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _parties.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *p = [_parties objectAtIndex:indexPath.row];
    cell.textLabel.text = [p objectForKey:@"name"];
    return cell;
}

@end
