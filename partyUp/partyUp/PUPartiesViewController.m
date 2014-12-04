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
#import "PUPlaceCell.h"
#import "PUPlacesService.h"


typedef NS_ENUM(NSUInteger, PartiesSections) {
    Today,
    ThisWeek,
    NextWeek,
};

typedef NS_ENUM(NSUInteger, PlacesSections) {
    LessThan5km,
    Between5kmAnd20km,
    MoreThan20km,
};

typedef NS_ENUM(NSUInteger, partiesOrPlacesControl) {
    parties,
    places,
};

#define HEADER_HEIGHT 50.0f

@interface PUPartiesViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *errorMsgContainer;
@property (strong, nonatomic) IBOutlet UILabel *errorMsg;

@property (strong, nonatomic) UISegmentedControl *partiesOrPlacesControl;
@property (assign, nonatomic) NSInteger lastSegmentControlIndex;

@property(nonatomic,strong)NSArray *parties;
@property(nonatomic,strong)PUPartyService *service;


@property(nonatomic,strong)NSArray *places;
@property(nonatomic,strong)PUPlacesService *placeService;

@end

static NSString *partyCellID = @"partyCellID";
static NSString *placeCellID = @"placeCellID";
static NSString *headerCellID = @"headerCellID";

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showStatusBar];
    [self hidesNavigationBackButton];
    [self setUpServices];
    [self fetchParties];
}

-(void)showStatusBar{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

-(void)setUpServices{
    _service = [PUPartyService new];
    _placeService = [PUPlacesService new];
}

-(void)cleanTableView{
    _parties = @[];
    _places = @[];
    [_collectionView reloadData];
}

-(void)fetchPartiesForPlace:(PUPlace*)place{
    [self cleanTableView];
    [_service fetchPartiesForPlace:place completion:^(NSArray *parties, NSError *error) {
        if(!error){
            [self successOnFetchParties:parties];
        }
    }];
}

-(void)fetchPlaces{
    [self cleanTableView];
    [_activityIndicator startAnimating];
    [_placeService fetchPlacesNearMe:^(NSArray *places, NSError *error) {
        [_activityIndicator stopAnimating];
        if(!error){
            [self successOnFetchPlaces:places];
        }
    }];;
}

-(void)successOnFetchPlaces:(NSArray*)places{
    if(places.count == 0)
        [self noPlacesFound];
    
    [self splitSectionPlaces:places];
    [self refreshTableView];
}





-(void)showErrorMsg:(NSString*)error{
    _errorMsgContainer.hidden = NO;
    if(error)
        _errorMsg.text = error;
}

-(void)refreshParties{
    _parties = [NSMutableArray array];
    [_collectionView reloadData];
    [self fetchParties];
}

-(void)viewWillAppear:(BOOL)animated{
    if(self.parentViewController.navigationItem.titleView == nil)
        [self setUpSegmentControlOnNavigationBar];
}


-(void)setUpSegmentControlOnNavigationBar{
    _partiesOrPlacesControl = [[UISegmentedControl alloc] initWithItems:@[@"Festas",@"Lugares"]];
    [_partiesOrPlacesControl setWidth:100 forSegmentAtIndex:0];
    [_partiesOrPlacesControl setWidth:100 forSegmentAtIndex:1];
    [_partiesOrPlacesControl addTarget:self action:@selector(changeValueSegmentControl:) forControlEvents:UIControlEventValueChanged];
    [_partiesOrPlacesControl setSelectedSegmentIndex:_lastSegmentControlIndex];
    [self enablePartiesOrPlacesControlInteraction:[self hasParties]];
    self.parentViewController.navigationItem.titleView = _partiesOrPlacesControl;
}

-(void)enablePartiesOrPlacesControlInteraction:(BOOL)enable{
    _partiesOrPlacesControl.enabled = enable;
    _partiesOrPlacesControl.userInteractionEnabled = enable;
}

-(void)changeValueSegmentControl:(id)sender{
    _lastSegmentControlIndex = _partiesOrPlacesControl.selectedSegmentIndex;
    if(_lastSegmentControlIndex == parties){
        [self fetchParties];
    }else{
        [self fetchPlaces];
    }
    
}





-(void)hidesNavigationBackButton{
    self.parentViewController.navigationItem.hidesBackButton = YES;
}

-(void)fetchParties{
    [self cleanTableView];
    [_activityIndicator startAnimating];
    [_service fetchPartiesNearMe:^(NSArray *parties, NSError *error) {
        [_activityIndicator stopAnimating];
        [self enablePartiesOrPlacesControlInteraction:YES];
        if(!error)
            [self successOnFetchParties:parties];
        else
            [self showErrorMsg:@"Aconteceu um erro inesperado, tente mais tarde."];
    }];
}

-(void)noPartiesFound{
    [self showErrorMsg:nil];
}

-(void)noPlacesFound{
    [self showErrorMsg:@"Não encontramos nenhuma lugar cadastrado próximo a você!"];
}

-(void)successOnFetchParties:(NSArray*)parties{
    if(parties.count == 0)
        [self noPartiesFound];
    
    [self splitSectionParties:parties];
    [self refreshTableView];
}

-(void)splitSectionPlaces:(NSArray*)places{
    NSMutableArray *lessThan5km = [NSMutableArray array];
    NSMutableArray *between5kmAnd20km = [NSMutableArray array];
    NSMutableArray *moreThan20km = [NSMutableArray array];
    for(PUPlace *p in places){
        if(p.distanceInKm < 5)
            [lessThan5km addObject:p];
        else if(p.distanceInKm > 5 && p.distanceInKm < 20)
            [between5kmAnd20km addObject:p];
        else
            [moreThan20km addObject:p];
    }
    _places = @[lessThan5km,between5kmAnd20km,moreThan20km];
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
-(void)refreshTableView{
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)hasParties{
    return (_parties && _parties.count > 0);
}

-(PUParty*)partyAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *parties = [_parties objectAtIndex:indexPath.section];
    return [parties objectAtIndex:indexPath.row];
}

-(PUPlace*)placeAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *places = [_places objectAtIndex:indexPath.section];
    return [places objectAtIndex:indexPath.row];
}

-(BOOL)hasItemsInSection:(NSInteger)section{
    
    if(_lastSegmentControlIndex == parties){
        NSArray *parties = [_parties objectAtIndex:section];
        return parties.count > 0;
    }else{
        NSArray *places = [_places objectAtIndex:section];
        return places.count > 0;
    }
    

}

-(NSString*)headerMessageForSection:(NSInteger)section{
    
    if(_lastSegmentControlIndex == parties){
    
        if(section == Today)
            return @"Hoje";
        else if(section == ThisWeek)
            return @"Essa Semana";
        else
            return @"Semana que vem";
    
    }else{
       
        if(section == LessThan5km)
            return @"Menos de 5km";
        else if(section == Between5kmAnd20km)
            return @"Entre 5km e 20 km";
        else
            return @"Mais de 20 km";
    }
    
    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"showParty" isEqualToString:segue.identifier]){
        NSArray *paths = [_collectionView indexPathsForSelectedItems];
        PUParty *selectedParty = [self partyAtIndexPath:[paths firstObject]];
        PUPartyViewController *dest = (PUPartyViewController*)[segue destinationViewController];
        dest.party = selectedParty;
    }
}


#pragma mark - CollectionView Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    if(_lastSegmentControlIndex == parties)
        return _parties.count;
    else
        return _places.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(_lastSegmentControlIndex == parties){
        NSArray *parties =  [_parties objectAtIndex:section];
        return parties.count;
    }else{
        NSArray *places =  [_places objectAtIndex:section];
        return places.count;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(_lastSegmentControlIndex == parties)
        return [self collectionView:collectionView partyCellAtIndexPath:indexPath];
    else
        return [self collectionView:collectionView placeCellAtIndexPath:indexPath];
}

-(PUPartyCell *)collectionView:(UICollectionView *)collectionView partyCellAtIndexPath:(NSIndexPath *)indexPath{
    PUPartyCell *cell = (PUPartyCell*)[collectionView dequeueReusableCellWithReuseIdentifier:partyCellID forIndexPath:indexPath];
    PUParty *party = [self partyAtIndexPath:indexPath];
    [cell fill:party];
    return cell;
}

-(PUPlaceCell *)collectionView:(UICollectionView *)collectionView placeCellAtIndexPath:(NSIndexPath *)indexPath{
    PUPlaceCell *cell = (PUPlaceCell*)[collectionView dequeueReusableCellWithReuseIdentifier:placeCellID forIndexPath:indexPath];
    PUPlace *place = [self placeAtIndexPath:indexPath];
    [cell fill:place];
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
