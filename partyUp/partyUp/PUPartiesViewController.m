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
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong)NSArray *parties;
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
    [self setUpPartyService];
    [self fetchParties];
}

-(void)showStatusBar{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

-(void)setUpPartyService{
    _service = [PUPartyService new];
}

-(void)cleanPartiesTableView{
    _parties = @[];
    [_collectionView reloadData];
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
    [_collectionView reloadData];
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
            [_activityIndicator stopAnimating];
            [self successOnFetchParties:parties];
        }
    }];
}

-(void)successOnFetchParties:(NSArray*)parties{
    [self splitSectionParties:parties];
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
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(PUParty*)partyAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *parties = [_parties objectAtIndex:indexPath.section];
    return [parties objectAtIndex:indexPath.row];
}

-(BOOL)hasItemsInSection:(NSInteger)section{
    NSArray *parties = [_parties objectAtIndex:section];
    return parties.count > 0;
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
    if([@"showParty" isEqualToString:segue.identifier]){
        NSArray *paths = [_collectionView indexPathsForSelectedItems];
        PUParty *selectedParty = [self partyAtIndexPath:[paths firstObject]];
        PUPartyViewController *dest = (PUPartyViewController*)[segue destinationViewController];
        dest.partyId = selectedParty.partyId;
    }
}


#pragma mark - CollectionView Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _parties.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *parties =  [_parties objectAtIndex:section];
    return parties.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    PUPartyCell *cell = (PUPartyCell*)[collectionView dequeueReusableCellWithReuseIdentifier:partyCellID forIndexPath:indexPath];
    PUParty *party = [self partyAtIndexPath:indexPath];
    [cell fill:party];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(![self hasItemsInSection:section])
        return CGSizeMake(0, 0);
    
    CGFloat width = self.view.bounds.size.width;
    return CGSizeMake(width, HEADER_HEIGHT);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    PUHeaderCell *headerView = (PUHeaderCell*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerCellID forIndexPath:indexPath];
    headerView.message.text = [self headerMessageForSection:indexPath.section];
    return headerView;
}


@end
