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
#import "PUSearchCell.h"


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

@interface PUPartiesViewController ()<UICollectionViewDataSource,
                                        UICollectionViewDelegate,
                                        UICollectionViewDelegateFlowLayout,
                                        PUSearchCellDelegate>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIView *errorMsgContainer;
@property (strong, nonatomic) IBOutlet UILabel *errorMsg;

@property (strong, nonatomic) UISegmentedControl *partiesOrPlacesControl;
@property (assign, nonatomic) NSInteger lastSegmentControlIndex;

@property(nonatomic,strong)NSArray *parties;
@property(nonatomic,strong)PUPartyService *service;

@property(nonatomic,strong)PUSearchCell *searchCell;


@property(nonatomic,strong)NSArray *places;
@property(nonatomic,strong)PUPlacesService *placeService;

@end

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpSearchIconOnNavigation];
    [self showStatusBar];
    [self hidesNavigationBackButton];
    [self setUpServices];
    [self fetchParties];
}

-(void)setUpSearchIconOnNavigation{
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                            target:self action:@selector(clickOnSearchIcon)];
    
    self.parentViewController.navigationItem.rightBarButtonItem = button;
}

-(void)clickOnSearchIcon{
    NSIndexPath *searchCellIndexPath = [NSIndexPath indexPathForItem:0 inSection:0];
    [_collectionView scrollToItemAtIndexPath:searchCellIndexPath
                            atScrollPosition:UICollectionViewScrollPositionTop
                                    animated:YES];
    [self requestFocusOnSearchBar];
}

-(void)showStatusBar{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
}

-(void)setUpServices{
    _service = [PUPartyService new];
    _placeService = [PUPlacesService new];
}

-(void)fetchPlaces{
    [self showLoadingState];
    [_placeService fetchPlacesNearMe:^(NSArray *places, NSError *error) {
        [_activityIndicator stopAnimating];
        if(!error)
            [self successOnFetchPlaces:places];
        else
            [self showUnknownError];
    }];
}

-(void)successOnFetchPlaces:(NSArray*)places{
    if(places.count == 0){
        [self showErrorState];
        [self noPlacesFound];
        return;
    }
    [self splitSectionPlaces:places];
    [self refreshTableView];
}

-(void)showLoadingState{
    _errorMsgContainer.hidden = YES;
    _collectionView.hidden = YES;
    [_activityIndicator startAnimating];
}

-(void)showErrorState{
    _errorMsgContainer.hidden = NO;
    _collectionView.hidden = YES;
}

-(void)showResultsState{
    _errorMsgContainer.hidden = YES;
    _collectionView.hidden = NO;
}

-(void)showErrorMsg:(NSString*)error{
    _errorMsgContainer.hidden = NO;
    if(error)
        _errorMsg.text = error;
}


-(void)viewWillAppear:(BOOL)animated{
    if(self.parentViewController.navigationItem.titleView == nil){
        [self setUpSegmentControlOnNavigationBar];
    }
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
    [self resignSearchBar];
    _lastSegmentControlIndex = _partiesOrPlacesControl.selectedSegmentIndex;
    if(_lastSegmentControlIndex == parties)
        [self didSelectPartiesOnSegmentControl];
    else
        [self didSelectPlacesOnSegmentControl];
}

-(void)didSelectPartiesOnSegmentControl{
    if(_parties.count == 0)
        [self fetchParties];
    else
        [self refreshTableView];
}

-(void)didSelectPlacesOnSegmentControl{
    if(_places.count == 0)
        [self fetchPlaces];
    else
        [self refreshTableView];
}

-(void)hidesNavigationBackButton{
    self.parentViewController.navigationItem.hidesBackButton = YES;
}

-(void)fetchPartiesForPlace:(PUPlace *)place{
    [self showLoadingState];
    [_activityIndicator startAnimating];
    [_service fetchPartiesForPlace:place completion:^(NSArray *parties, NSError *error) {
        [_activityIndicator stopAnimating];
        [self enablePartiesOrPlacesControlInteraction:YES];
        if(!error)
            [self successOnFetchParties:parties forPlace:place];
        else
            [self showUnknownError];
    }];
}

-(void)showUnknownError{
    [self showErrorMsg:@"Aconteceu um erro inesperado, tente mais tarde."];
}

-(void)fetchParties{
    [self showLoadingState];
    [_service fetchPartiesNearMe:^(NSArray *parties, NSError *error) {
        [_activityIndicator stopAnimating];
        [self enablePartiesOrPlacesControlInteraction:YES];
        if(!error)
            [self successOnFetchParties:parties];
        else
            [self showUnknownError];
    }];
}

-(void)noPartiesFoundFor:(PUPlace*)place{
    NSString *msg = [NSString stringWithFormat:@"No momento não temos nenhuma festa cadastrada para %@",place.name];
    [self showErrorMsg:msg];
}

-(void)noPartiesFoundNear{
    [self showErrorMsg:@"No momento não temos nenhuma festa próximo a você"];
}

-(void)noPlacesFound{
    [self showErrorMsg:@"Não encontramos nenhum lugar cadastrado próximo a você!"];
}

-(void)successOnFetchParties:(NSArray*)parties{
    if(parties.count == 0){
        [self showErrorState];
        [self noPartiesFoundNear];
        return;
    }
    [self splitSectionParties:parties];
    [self refreshTableView];
}

-(void)successOnFetchParties:(NSArray*)parties forPlace:(PUPlace*)place{
    if(parties.count == 0){
        [self showErrorState];
        [self noPartiesFoundFor:place];
        return;
    }
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
    [self showResultsState];
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
    NSInteger index = indexPath.section -1;
    NSArray *parties = [_parties objectAtIndex:index];
    return [parties objectAtIndex:indexPath.row];
}

-(PUPlace*)placeAtIndexPath:(NSIndexPath*)indexPath{
    NSInteger index = indexPath.section -1;
    NSArray *places = [_places objectAtIndex:index];
    return [places objectAtIndex:indexPath.row];
}

-(BOOL)hasItemsInSection:(NSInteger)section{
    NSInteger index = section -1;
    if(_lastSegmentControlIndex == parties){
        NSArray *parties = [_parties objectAtIndex:index];
        return parties.count > 0;
    }else{
        NSArray *places = [_places objectAtIndex:index];
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
    [self resignSearchBar];
    if([@"showParty" isEqualToString:segue.identifier]){
        NSArray *paths = [_collectionView indexPathsForSelectedItems];
        PUParty *selectedParty = [self partyAtIndexPath:[paths firstObject]];
        PUPartyViewController *dest = (PUPartyViewController*)[segue destinationViewController];
        dest.party = selectedParty;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self resignSearchBar];
    if(_lastSegmentControlIndex != places)
        return;
    
    _lastSegmentControlIndex = parties;
    [self enablePartiesOrPlacesControlInteraction:NO];
    [_partiesOrPlacesControl setSelectedSegmentIndex:_lastSegmentControlIndex];
    PUPlace *place = [self placeAtIndexPath:indexPath];
    [self fetchPartiesForPlace:place];
}


#pragma mark - CollectionView Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    NSInteger numberOfSections = 1;//Added SearchSection
    
    if(_lastSegmentControlIndex == parties)
        numberOfSections += _parties.count;
    else
        numberOfSections += _places.count;
    
    return numberOfSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(section == 0){
        
        return 1;
   
    }else{
        NSInteger index = section -1; //Due to have now the search section
        if(_lastSegmentControlIndex == parties){
            NSArray *parties =  [_parties objectAtIndex:index];
            return parties.count;
        }else{
            NSArray *places =  [_places objectAtIndex:index];
            return places.count;
        }
        
    }
    
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        
        return [self collectionView:collectionView searchCellAtIndexPath:indexPath];
    
    }else{
    
        if(_lastSegmentControlIndex == parties)
            return [self collectionView:collectionView partyCellAtIndexPath:indexPath];
        else
            return [self collectionView:collectionView placeCellAtIndexPath:indexPath];
    }
}

-(PUSearchCell *)collectionView:(UICollectionView *)collectionView searchCellAtIndexPath:(NSIndexPath *)indexPath{
    PUSearchCell *cell = (PUSearchCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[PUSearchCell cellID] forIndexPath:indexPath];
    [cell config:self];
    _searchCell = cell;
    return cell;
}

-(PUPartyCell *)collectionView:(UICollectionView *)collectionView partyCellAtIndexPath:(NSIndexPath *)indexPath{
    PUPartyCell *cell = (PUPartyCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[PUPartyCell cellID] forIndexPath:indexPath];
    PUParty *party = [self partyAtIndexPath:indexPath];
    [cell fill:party];
    return cell;
}

-(PUPlaceCell *)collectionView:(UICollectionView *)collectionView placeCellAtIndexPath:(NSIndexPath *)indexPath{
    PUPlaceCell *cell = (PUPlaceCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[PUPlaceCell cellID] forIndexPath:indexPath];
    PUPlace *place = [self placeAtIndexPath:indexPath];
    [cell fill:place];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        CGFloat width = self.view.bounds.size.width;
        return CGSizeMake(width, 44);
    }else{
    
        if(_lastSegmentControlIndex == parties){
            return CGSizeMake(300, 240);
        }else
            return CGSizeMake(300, 275);
        
    }
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0 || ![self hasItemsInSection:section])
        return CGSizeMake(0, 0);
    
    CGFloat width = self.view.bounds.size.width;
    return CGSizeMake(width, HEADER_HEIGHT);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    PUHeaderCell *headerView = (PUHeaderCell*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[PUHeaderCell cellID] forIndexPath:indexPath];
    headerView.message.text = [self headerMessageForSection:indexPath.section];
    return headerView;
}

-(void)resignSearchBar{
    [_searchCell resignSearchBar];
}

-(void)requestFocusOnSearchBar{
    [_searchCell requestFocus];
}

-(void)search:(NSString *)query{
    if(_lastSegmentControlIndex == parties){
    
    }else
        [self fetchPlacesFor:query];
}

-(void)fetchPlacesFor:(NSString*)query{
    [self showLoadingState];
    [_placeService fetchPlacesForQuery:query completion:^(NSArray *places, NSError *error) {
        [_activityIndicator stopAnimating];
        if(!error)
            [self successOnFetchPlaces:places];
        else
            [self showUnknownError];
    }];
}


@end
