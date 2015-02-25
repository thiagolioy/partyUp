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
#import "PUErrorFeedbackCell.h"


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

@property (strong, nonatomic) UISegmentedControl *partiesOrPlacesControl;
@property (assign, nonatomic) NSInteger lastSegmentControlIndex;

@property(nonatomic,strong)NSArray *partiesSectionHeaders;
@property(nonatomic,strong)NSArray *placesSectionHeaders;

@property(nonatomic,strong)NSArray *parties;
@property(nonatomic,strong)PUPartyService *service;

@property(nonatomic,strong)PUSearchCell *searchCell;
@property(nonatomic,strong)PUErrorFeedbackCell *errorFeedbackCell;

@property(nonatomic,strong)NSArray *places;
@property(nonatomic,strong)PUPlacesService *placeService;
@property(nonatomic,strong)UIRefreshControl *refreshControl;

@property(nonatomic,assign)BOOL hasErrorFeedback;

@end


#define LIGHT_GRAY [UIColor colorWithRed:236.0f/255.0f green:239.0f/255.0f blue:241.0f/255.0f alpha:1]

@implementation PUPartiesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showStatusBar];
    [self hidesNavigationBackButton];
    [self setUpServices];
    [self setUpMessageHeaders];
    [self setUpPullToRefresh];
    [self fetchParties];
    [self addNotifications];
}

-(void)setUpPullToRefresh{
    _refreshControl = [[UIRefreshControl alloc] init];
    _refreshControl.tintColor = LIGHT_GRAY;
    [_refreshControl addTarget:self action:@selector(refreshCollectionAction) forControlEvents:UIControlEventValueChanged];
    [self.collectionView addSubview:_refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
}

-(void)refreshCollectionAction{
    if([self isPartiesSegmentSelected])
        [self fetchParties];
    else
        [self fetchPlaces];
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
    if(![_refreshControl isRefreshing])
        [self showLoadingState];
    [_placeService fetchPlacesNearMe:^(NSArray *places, NSError *error) {
        [_activityIndicator stopAnimating];
        [_refreshControl endRefreshing];
        if(!error)
            [self successOnFetch:places forQuery:nil orPlace:nil];
        else
            [self showUnknownError];
    }];
}

-(NSString*)errorFeedbackMsgForQuery:(NSString*)query orPlace:(PUPlace*)place{
    NSString *msg = @"";
    if([self isPartiesSegmentSelected])
       msg = @"Não encontramos nenhuma festa";
    else
       msg = @"Não encontramos nenhum lugar";
    
    if(query)
        return [NSString stringWithFormat:@"%@ para \"%@\".",msg,query];
    else if(place)
        return [NSString stringWithFormat:@"%@ para \"%@\".",msg,place.name];
    else
        return [NSString stringWithFormat:@"%@ próximo a você.",msg];;
}

-(void)successOnFetch:(NSArray*)list forQuery:(NSString*)query orPlace:(PUPlace*)place{
    if(list.count == 0){
        [self showErrorState];
        NSString *msg = [self errorFeedbackMsgForQuery:query orPlace:place];
        [self showErrorMsg:msg];
        return;
    }
    if([self isPartiesSegmentSelected])
        _parties = [PUPartiesAndPlacesHelper splitPartiesSection:list];
    else
        _places = [PUPartiesAndPlacesHelper splitPlacesSection:list];
    
    [self showResultsState];
    [self refreshTableView];
}


-(void)showLoadingState{
    _collectionView.hidden = YES;
    [_activityIndicator startAnimating];
}

-(BOOL)isShowingErrorState{
    return  YES;
}

-(void)showErrorState{
    _hasErrorFeedback = YES;
    _collectionView.hidden = NO;
    [self refreshTableView];
}

-(void)showResultsState{
    _hasErrorFeedback = NO;
    _collectionView.hidden = NO;
}

-(void)showErrorMsg:(NSString*)error{
    if(_errorFeedbackCell)
        _errorFeedbackCell.errorMsg.text = error;
}

- (void) addNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(fetchParties)
                                                 name:@"UPDATED_RADIUS_DISTANCE"
                                               object:nil];
    
    
}
-(void) removeNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"UPDATED_RADIUS_DISTANCE"
                                                  object:nil];
}


-(void)viewWillAppear:(BOOL)animated{
    if(self.parentViewController.navigationItem.titleView == nil)
        [self setUpSegmentControlOnNavigationBar];
    if(self.parentViewController.navigationItem.rightBarButtonItem == nil)
        [self setUpSearchIconOnNavigation];
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
    [self fetchParties];
}

-(void)didSelectPlacesOnSegmentControl{
    [_searchCell setPlaceholderText:@"Busque lugares"];
    [self fetchPlaces];
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
            [self successOnFetch:parties forQuery:nil orPlace:place];
        else
            [self showUnknownError];
    }];
}

-(void)showUnknownError{
    [self showErrorMsg:@"Aconteceu um erro inesperado, tente mais tarde."];
}

-(void)fetchParties{
    if(![_refreshControl isRefreshing])
        [self showLoadingState];
    [_service fetchPartiesNearMe:^(NSArray *parties, NSError *error) {
        [_activityIndicator stopAnimating];
        [_refreshControl endRefreshing];
        [self enablePartiesOrPlacesControlInteraction:YES];
        if(!error)
            [self successOnFetch:parties forQuery:nil orPlace:nil];
        else
            [self showUnknownError];
    }];
}



-(void)refreshTableView{
    [_collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [self removeNotifications];
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

-(BOOL)shouldShowErrorFeedback{
    return _hasErrorFeedback;
}

-(BOOL)shouldShowResults{
    return ![self shouldShowErrorFeedback];
}

#pragma mark - CollectionView Methods
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{

    NSInteger numberOfSections = 1;
    
    if([self shouldShowErrorFeedback])
        numberOfSections++;
    else{
        if([self isPartiesSegmentSelected])
            numberOfSections += _parties.count;
        else
            numberOfSections += _places.count;
    }
    
    return numberOfSections;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if(section == searchSection)
        return [self numberOfItemsInSearchSection];
    
    if([self shouldShowErrorFeedback])
        return [self numberOfItemsInErrorFeedback];
    else{
        NSInteger index = [self indexForSectionDifferentThanSearch:section];
        if([self isPartiesSegmentSelected])
            return [self numberOfItemsInPartiesSection:index];
        else
            return [self numberOfItemsInPlacesSection:index];
    }
}
-(NSInteger)numberOfItemsInErrorFeedback{
    return 1;
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

    if([self shouldShowErrorFeedback])
        return [self collectionView:collectionView errorFeedbackCellAtIndexPath:indexPath];
    else{
        if([self isPartiesSegmentSelected])
            return [self collectionView:collectionView partyCellAtIndexPath:indexPath];
        else
            return [self collectionView:collectionView placeCellAtIndexPath:indexPath];
    }
}

-(PUErrorFeedbackCell *)collectionView:(UICollectionView *)collectionView errorFeedbackCellAtIndexPath:(NSIndexPath *)indexPath{
    PUErrorFeedbackCell *cell = (PUErrorFeedbackCell*)[collectionView dequeueReusableCellWithReuseIdentifier:[PUErrorFeedbackCell cellID] forIndexPath:indexPath];
    _errorFeedbackCell = cell;
    return cell;
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
    
    if([self shouldShowErrorFeedback])
        return [PUErrorFeedbackCell cellSize];
    else{
        if([self isPartiesSegmentSelected])
            return CGSizeMake(300, 240);
        else
            return CGSizeMake(300, 275);
    }
    

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if(section == 0 ||  [self shouldShowErrorFeedback] ||![self hasItemsInSection:section] )
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
            [self successOnFetch:parties forQuery:query orPlace:nil];
        else
            [self showUnknownError];
    }];
    
}

-(void)fetchPlacesFor:(NSString*)query{
    [self showLoadingState];
    [_placeService fetchPlacesForQuery:query completion:^(NSArray *places, NSError *error) {
        [_activityIndicator stopAnimating];
        if(!error)
            [self successOnFetch:places forQuery:query orPlace:nil];
        else
            [self showUnknownError];
    }];
}


@end
