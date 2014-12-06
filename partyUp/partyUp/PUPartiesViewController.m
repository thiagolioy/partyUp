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
#import "PUPartiesAndPlacesHelper.h"


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

typedef NS_ENUM(NSUInteger, Sections) {
    searchSection,
    partiesSection,
    placesSection,
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

@property(nonatomic,strong)NSArray *partiesSectionHeaders;
@property(nonatomic,strong)NSArray *placesSectionHeaders;

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
    [self setUpMessageHeaders];
}

-(void)setUpMessageHeaders{
    _partiesSectionHeaders = @[ @"Hoje",@"Essa Semana",@"Semana que vem"];
    _placesSectionHeaders = @[@"Menos de 5km",@"Entre 5km e 20 km",@"Mais de 20 km"];
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
    _places = [PUPartiesAndPlacesHelper splitPlacesSection:places];
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
    [self resignSearchBar];
    _lastSegmentControlIndex = _partiesOrPlacesControl.selectedSegmentIndex;
    if([self isPartiesSegmentSelected])
        [self didSelectPartiesOnSegmentControl];
    else
        [self didSelectPlacesOnSegmentControl];
}

-(void)didSelectPartiesOnSegmentControl{
    [_searchCell setPlaceholderText:@"Busque festas"];
    if(_parties.count == 0)
        [self fetchParties];
    else
        [self refreshTableView];
}

-(void)didSelectPlacesOnSegmentControl{
    [_searchCell setPlaceholderText:@"Busque lugares"];
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
    _parties = [PUPartiesAndPlacesHelper splitPartiesSection:parties];
    [self refreshTableView];
}

-(void)successOnFetchParties:(NSArray*)parties forPlace:(PUPlace*)place{
    if(parties.count == 0){
        [self showErrorState];
        [self noPartiesFoundFor:place];
        return;
    }
    _parties = [PUPartiesAndPlacesHelper splitPartiesSection:parties];
    [self refreshTableView];
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

-(NSInteger)indexForSectionDifferentThanSearch:(NSInteger)section{
    return (section -1);
}

-(PUParty*)partyAtIndexPath:(NSIndexPath*)indexPath{
    NSInteger index = [self indexForSectionDifferentThanSearch:indexPath.section];
    NSArray *parties = [_parties objectAtIndex:index];
    return [parties objectAtIndex:indexPath.row];
}

-(PUPlace*)placeAtIndexPath:(NSIndexPath*)indexPath{
    NSInteger index = [self indexForSectionDifferentThanSearch:indexPath.section];
    NSArray *places = [_places objectAtIndex:index];
    return [places objectAtIndex:indexPath.row];
}

-(BOOL)hasItemsInSection:(NSInteger)section{
    NSInteger index = [self indexForSectionDifferentThanSearch:section];
    if(_lastSegmentControlIndex == parties){
        NSArray *parties = [_parties objectAtIndex:index];
        return parties.count > 0;
    }else{
        NSArray *places = [_places objectAtIndex:index];
        return places.count > 0;
    }
    

}

-(BOOL)isPartiesSegmentSelected{
    return _lastSegmentControlIndex == parties;
}

-(BOOL)isPlacesSegmentSelected{
    return ![self isPartiesSegmentSelected];
}

-(NSString*)headerMessageForSection:(NSInteger)section{
    if([self isPartiesSegmentSelected])
        return [_partiesSectionHeaders objectAtIndex:section];
    return [_placesSectionHeaders objectAtIndex:section];
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
    if(![self isPlacesSegmentSelected])
        return;
    
    _lastSegmentControlIndex = parties;
    [self enablePartiesOrPlacesControlInteraction:NO];
    [_partiesOrPlacesControl setSelectedSegmentIndex:_lastSegmentControlIndex];
    PUPlace *place = [self placeAtIndexPath:indexPath];
    [self fetchPartiesForPlace:place];
}


#pragma mark - CollectionView Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    NSInteger numberOfSections = 1;
    
    if([self isPartiesSegmentSelected])
        numberOfSections += _parties.count;
    else
        numberOfSections += _places.count;
    
    return numberOfSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(section == searchSection)
        return [self numberOfItemsInSearchSection];

    NSInteger index = [self indexForSectionDifferentThanSearch:section];
    if([self isPartiesSegmentSelected])
        return [self numberOfItemsInPartiesSection:index];
    else
        return [self numberOfItemsInPlacesSection:index];

}
-(NSInteger)numberOfItemsInSearchSection{
    return 1;
}
-(NSInteger)numberOfItemsInPartiesSection:(NSInteger)index{
    return ((NSArray*)[_parties objectAtIndex:index]).count;
}
-(NSInteger)numberOfItemsInPlacesSection:(NSInteger)index{
    return ((NSArray*)[_places objectAtIndex:index]).count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    if(indexPath.section == searchSection)
        return [self collectionView:collectionView searchCellAtIndexPath:indexPath];

    if([self isPartiesSegmentSelected])
        return [self collectionView:collectionView partyCellAtIndexPath:indexPath];
    else
        return [self collectionView:collectionView placeCellAtIndexPath:indexPath];

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
    
    if(indexPath.section == searchSection){
        CGFloat width = self.view.bounds.size.width;
        return CGSizeMake(width, 44);
    }
    
    if([self isPartiesSegmentSelected])
        return CGSizeMake(300, 240);
    else
        return CGSizeMake(300, 275);

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0 || ![self hasItemsInSection:section])
        return CGSizeMake(0, 0);
    
    CGFloat width = self.view.bounds.size.width;
    return CGSizeMake(width, HEADER_HEIGHT);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    PUHeaderCell *headerView = (PUHeaderCell*)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:[PUHeaderCell cellID] forIndexPath:indexPath];
    NSInteger index = [self indexForSectionDifferentThanSearch:indexPath.section];
    headerView.message.text = [self headerMessageForSection:index];
    return headerView;
}

-(void)resignSearchBar{
    [_searchCell resignSearchBar];
}

-(void)requestFocusOnSearchBar{
    [_searchCell requestFocus];
}

-(void)search:(NSString *)query{
    if([self isPartiesSegmentSelected])
        [self fetchPartiesFor:query];
    else
        [self fetchPlacesFor:query];
}

-(void)fetchPartiesFor:(NSString*)query{
    [self showLoadingState];
    [_service fetchPartiesForQuery:query completion:^(NSArray *parties, NSError *error) {
        [_activityIndicator stopAnimating];
        if(!error)
            [self successOnFetchParties:parties];
        else
            [self showUnknownError];
    }];
    
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
