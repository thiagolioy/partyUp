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
#import "PartyService.h"

@interface PUPartiesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *partiesTableView;
@property(nonatomic,strong)NSMutableArray *parties;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger partiesPerPage;
@property(nonatomic,assign)NSInteger partiesTotalCount;
@property(nonatomic,assign)PartyService *service;
@end

static NSString *cellID = @"partyCellID";

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hidesNavigationBackButton];
    [self setUpPullToRefreshAndInfiniteScrolling];
    [self setUpPagination];
    
    _service = [PartyService new];
    
    [self fetchParties];
}

-(void)setUpPagination{
    _currentPage = 0;
    _partiesPerPage = 2;
}

-(void)setUpPullToRefreshAndInfiniteScrolling{
    __weak typeof(self)weakSelf = self;
    [_partiesTableView addPullToRefreshWithActionHandler:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf refreshParties];
    }];
    
    [_partiesTableView addInfiniteScrollingWithActionHandler:^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        if(strongSelf.partiesPerPage*strongSelf.currentPage<strongSelf.partiesTotalCount)
            [strongSelf fetchNextParties];
    }];
}

-(void)refreshParties{
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
    [PFGeoPoint geoPointForCurrentLocationInBackground:^(PFGeoPoint *geoPoint, NSError *error) {
        if (!error) {
            PFQuery *placeQuery = [PFQuery queryWithClassName:@"Place"];
            [placeQuery whereKey:@"location" nearGeoPoint:geoPoint];
            [placeQuery orderByAscending:@"location"];
            placeQuery.limit = 10;
            
            
            PFQuery *query = [PFQuery queryWithClassName:@"Party"];
            [query includeKey:@"place"];
            [query whereKey:@"place" matchesQuery:placeQuery];
            query.cachePolicy = kPFCachePolicyNetworkElseCache;
            query.maxCacheAge = 60 * 60 * 24;
            
            
            query.limit = _partiesPerPage;
            [query countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                if(!error){
                    _partiesTotalCount = number;
                    query.skip = _partiesPerPage*_currentPage;
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if(!error){
                            [self parseResultIntoParties:objects];
                            [self refreshPartiesTableView];
                            [_partiesTableView.infiniteScrollingView stopAnimating];
                            
                        }
                    }];
                }
            }];
        }
    }];
}

-(void)fetchParties{
    [_service fetchPartiesNearMe:^(NSArray *parties, NSError *error) {
        if(!error){
            [self parseResultIntoParties:parties];
            [self setUpPartiesTableView];
            [self refreshPartiesTableView];
        }
    }];
}

-(void)parseResultIntoParties:(NSArray*)objects{
    NSMutableArray *partiesArray = [NSMutableArray arrayWithCapacity:objects.count];
    for(PFObject *o in objects){
        NSString *partyId = [o objectId];
        NSString *name =  o[@"name"];
        NSString *imageUrl =  o[@"promoImage"];
        [partiesArray addObject:@{@"partyId":partyId,
                                  @"name":name,
                                  @"promoImage":imageUrl}];
    }
    if(!_parties)
        _parties = [NSMutableArray array];
    [_parties addObjectsFromArray:(NSArray*)[partiesArray copy]];
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
    NSDictionary *p = [_parties objectAtIndex:indexPath.row];
    [cell fill:p];
    return cell;
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"proceedToParty" isEqualToString:segue.identifier]){
        NSIndexPath *path = [_partiesTableView indexPathForSelectedRow];
        NSDictionary *selectedParty = [_parties objectAtIndex:path.row];
        PUPartyViewController *dest = (PUPartyViewController*)[segue destinationViewController];
        dest.partyId = [selectedParty objectForKey:@"partyId"];
    }
}

@end
