//
//  PUPartiesViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartiesViewController.h"
#import "PUPartyTableViewCell.h"

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
    
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            PFQuery *query = [PFQuery queryWithClassName:@"Party"];
            [query whereKey:@"location" nearGeoPoint:geoPoint];
            [query orderByAscending:@"location"];
            query.limit = 5;
            

            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error){
                    NSMutableArray *partiesArray = [NSMutableArray arrayWithCapacity:objects.count];
                    for(PFObject *o in objects){
                        NSString *name =  o[@"name"];
                        NSString *imageUrl =  o[@"promoImage"];
                        [partiesArray addObject:@{@"name":name,
                                                  @"promoImage":imageUrl}];
                    }
                    _parties = (NSArray*)[partiesArray copy];
                    
                    _partiesTableView.dataSource = self;
                    _partiesTableView.delegate = self;
                    [_partiesTableView reloadData];
                }
            }];
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
    PUPartyTableViewCell *cell = (PUPartyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    NSDictionary *p = [_parties objectAtIndex:indexPath.row];
    [cell fill:p];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"Select row");
}

@end
