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
#import "PUSearchSuggestionsService.h"
#import "PUHeaderCell.h"
typedef NS_ENUM(NSUInteger, PartiesSections) {
    Today,
    ThisWeek,
    NextWeek,
};

@interface PUPartiesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *partiesTableView;
@property(nonatomic,strong)NSArray *parties;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger partiesPerPage;
@property(nonatomic,assign)NSInteger partiesTotalCount;
@property(nonatomic,strong)PUPartyService *service;
@property(nonatomic,strong)NSMutableDictionary *sectionParties;

@end

static NSString *cellID = @"partyCellID";

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self hidesNavigationBackButton];
    [self setUpPullToRefreshAndInfiniteScrolling];
    [self setUpPartyService];
    [self fetchSuggestionsAndStoreInCache];
    [self fetchParties];
}

-(void)fetchSuggestionsAndStoreInCache{
    PUSearchSuggestionsService *service = [PUSearchSuggestionsService new];
    [service fetchSuggestions:^(NSArray *suggestions, NSError *error) {
        
    }];
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
-(void)cleanPartiesTableView{
    _parties = @[];
    [_partiesTableView reloadData];
}

-(void)fetchPartiesForPlace:(PUPlace*)place{
    [self cleanPartiesTableView];
    [_service fetchPartiesForPlace:place completion:^(NSArray *parties, NSError *error) {
        if(!error){
            [self successOnFetchParties:parties];
        }
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

-(void)fetchParties{
    [_service fetchPartiesNearMe:^(NSArray *parties, NSError *error) {
        if(!error){
            [self successOnFetchParties:parties];
        }
    }];
}

-(void)successOnFetchParties:(NSArray*)parties{
    [self splitSectionParties:parties];
    [self setUpPartiesTableView];
    [self refreshPartiesTableView];
}


-(void)splitSectionParties:(NSArray*)parties{
    NSMutableArray *todays = [NSMutableArray array];
    NSMutableArray *thisWeek = [NSMutableArray array];
    NSMutableArray *nextWeek = [NSMutableArray array];
    for(PUParty *p in parties){
        if([NSCalendar isToday:p.date])
            [todays addObject:p];
        else if([NSCalendar isThisWeek:p.date])
            [thisWeek addObject:p];
        else
            [nextWeek addObject:p];
    }
    _parties = @[todays,thisWeek,nextWeek];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PUPartyTableViewCell *cell = (PUPartyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    PUParty *party = [self partyAtIndexPath:indexPath];
    [cell fill:party];
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_parties count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *parties =  [_parties objectAtIndex:section];
    return parties.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *cellID = @"PUHeaderCellID";
    PUHeaderCell *cell = (PUHeaderCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.message.text = [self headerMessageForSection:section];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray *parties =  [_parties objectAtIndex:section];
    return parties.count > 0 ? 44 : 0;
}

-(PUParty*)partyAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *parties = [_parties objectAtIndex:indexPath.section];
    return [parties objectAtIndex:indexPath.row];
}

-(NSString*)headerMessageForSection:(NSInteger)section{
    if(section == Today)
        return @"Hoje";
    else if(section == ThisWeek)
        return @"Essa Semana";
    else
        return @"Proxima Semana";
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"proceedToParty" isEqualToString:segue.identifier]){
        NSIndexPath *path = [_partiesTableView indexPathForSelectedRow];
        PUParty *selectedParty = [self partyAtIndexPath:path];
        PUPartyViewController *dest = (PUPartyViewController*)[segue destinationViewController];
        dest.partyId = selectedParty.partyId;
    }
}

@end
