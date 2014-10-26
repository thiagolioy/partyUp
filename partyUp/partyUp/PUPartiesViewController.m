//
//  PUPartiesViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartiesViewController.h"
#import "PUPartyCell.h"
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

#define HEADER_HEIGHT 50.0f

@interface PUPartiesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *parties;
@property(nonatomic,assign)NSInteger currentPage;
@property(nonatomic,assign)NSInteger partiesPerPage;
@property(nonatomic,assign)NSInteger partiesTotalCount;
@property(nonatomic,strong)PUPartyService *service;
@property(nonatomic,strong)NSMutableDictionary *sectionParties;

@end

static NSString *partyCellID = @"partyCellID";
static NSString *headerCellID = @"headerCellID";

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showStatusBar];
    [self hidesNavigationBackButton];
    [self setUpPullToRefreshAndInfiniteScrolling];
    [self setUpPartyService];
    [self fetchSuggestionsAndStoreInCache];
//    [self fetchParties];
    
    [self setUpPartiesDataSourceAndDelegate];
}

-(void)showStatusBar{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
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
//    __weak typeof(self)weakSelf = self;
//    [_partiesTableView addPullToRefreshWithActionHandler:^{
//        __strong typeof(weakSelf)strongSelf = weakSelf;
//        [strongSelf refreshParties];
//    }];
}
-(void)cleanPartiesTableView{
//    _parties = @[];
//    [_partiesTableView reloadData];
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
//    _parties = [NSMutableArray array];
//    [_partiesTableView reloadData];
//    [self fetchParties];
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
    [self setUpPartiesDataSourceAndDelegate];
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

-(void)setUpPartiesDataSourceAndDelegate{
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
}
-(void)refreshPartiesTableView{
//    [_partiesTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    PUPartyCell *cell = (PUPartyCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
//    PUParty *party = [self partyAtIndexPath:indexPath];
//    [cell fill:party];
//    return cell;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return [_parties count];
//}
//
//-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    NSArray *parties =  [_parties objectAtIndex:section];
//    return parties.count;
//}
//
//-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    static NSString *cellID = @"PUHeaderCellID";
//    PUHeaderCell *cell = (PUHeaderCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
//    cell.message.text = [self headerMessageForSection:section];
//    return cell;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    NSArray *parties =  [_parties objectAtIndex:section];
//    return parties.count > 0 ? 44 : 0;
//}
//
//-(PUParty*)partyAtIndexPath:(NSIndexPath*)indexPath{
//    NSArray *parties = [_parties objectAtIndex:indexPath.section];
//    return [parties objectAtIndex:indexPath.row];
//}

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
//        NSIndexPath *path = [_partiesTableView indexPathForSelectedRow];
//        PUParty *selectedParty = [self partyAtIndexPath:path];
//        PUPartyViewController *dest = (PUPartyViewController*)[segue destinationViewController];
//        dest.partyId = selectedParty.partyId;
    }
}


#pragma mark - CollectionView Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PUPartyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:partyCellID forIndexPath:indexPath];
    
    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGFloat width = self.view.bounds.size.width;
    return CGSizeMake(width, HEADER_HEIGHT);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    PUHeaderCell *headerView = (PUHeaderCell*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCellID forIndexPath:indexPath];

    headerView.message.text = @"Próxima semana";
    return headerView;
}


@end
