//
//  PUPartiesViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartiesViewController.h"
#import "PUPartyTableViewCell.h"
#import "PUPartyViewController.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "PUPartyService.h"

@interface PUPartiesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *partiesTableView;
@property(nonatomic,strong)NSMutableArray *parties;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger partiesPerPage;
@property(nonatomic,assign)NSInteger partiesTotalCount;
@property(nonatomic,strong)PUPartyService *service;

@property(nonatomic,strong)CLLocationManager *locationManager;
@end

static NSString *cellID = @"partyCellID";

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hidesNavigationBackButton];
    [self setUpPullToRefreshAndInfiniteScrolling];
    [self setUpPartyService];
    [self fetchParties];
}

-(void)setUpPartyService{
    _service = [PUPartyService new];
    _service.partiesPerFetch = 10;
    _service.skip = 0;
    _currentPage = 0;
}

-(void)setUpPullToRefreshAndInfiniteScrolling{
    __weak typeof(self)weakSelf = self;
    [_partiesTableView addPullToRefreshWithActionHandler:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshParties];
    }];
}

-(void)refreshParties{
    _parties = [NSMutableArray array];
    [_partiesTableView reloadData];
    [self fetchParties];
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title = @"Parties";
}

-(void)hidesNavigationBackButton{
    self.parentViewController.navigationItem.hidesBackButton = YES;
}

-(void)fetchNextParties{
    _currentPage++;
    _service.skip = _service.partiesPerFetch*_currentPage;
    
    [_service fetchPartiesNearMe:^(NSArray *parties, NSError *error) {
        if(!error){
            [self successOnFetchNextParties:parties];
        }
    }];
}

-(void)fetchParties{
    [_service fetchPartiesNearMe:^(NSArray *parties, NSError *error) {
        if(!error){
            [self successOnFetchParties:parties];
        }
    }];
}

-(void)successOnFetchParties:(NSArray*)parties{
    if(!_parties)
        _parties = [NSMutableArray array];
    [_parties addObjectsFromArray:parties];
    [self setUpPartiesTableView];
    [self refreshPartiesTableView];
}
-(void)successOnFetchNextParties:(NSArray*)parties{
    [_parties addObjectsFromArray:parties];
    [self refreshPartiesTableView];
    [_partiesTableView.infiniteScrollingView stopAnimating];
}

-(void)setUpPartiesTableView{
    _partiesTableView.dataSource = self;
    _partiesTableView.delegate = self;
}
-(void)refreshPartiesTableView{
    [_partiesTableView reloadData];
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
    PUParty *party = [_parties objectAtIndex:indexPath.row];
    [cell fill:party];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"proceedToParty" isEqualToString:segue.identifier]){
        NSIndexPath *path = [_partiesTableView indexPathForSelectedRow];
        PUParty *selectedParty = [_parties objectAtIndex:path.row];
        PUPartyViewController *dest = (PUPartyViewController*)[segue destinationViewController];
        dest.partyId = selectedParty.partyId;
    }
}

@end
