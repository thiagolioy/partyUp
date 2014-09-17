//
//  PUPlacesViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 9/8/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPlacesViewController.h"
#import "PUPlace.h"
#import "PUPlacesService.h"
#import "PUPartiesViewController.h"
#import "PUHeaderCell.h"
#import "PUSearchSuggestionsService.h"
#import "PUSearchSuggestion.h"

typedef NS_ENUM(NSUInteger, PlacesSections) {
    LessThan5KM,
    LessThan20KM,
    MoreThan20KM
};

@interface PUPlacesViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong) PUPlacesService *service;
@property(nonatomic,strong)NSArray *places;
@property(nonatomic,strong)NSArray *suggestions;

@property(nonatomic,strong)IBOutlet UITableView *placesTableView;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@end

@implementation PUPlacesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchSearchSuggestions];
    _searchBar.delegate = self;
}

-(void)fetchSearchSuggestions{
    PUSearchSuggestionsService *service = [PUSearchSuggestionsService new];
    [service fetchSuggestions:^(NSArray *suggestions, NSError *error) {
        if(error){
        }
        
        _suggestions = suggestions;
        
    }];
}

-(void)fetchPlaces{
    if(!_service)
        _service = [PUPlacesService new];
    
    _service.placesPerFetch = 50;
    [_service fetchPlacesNearMe:^(NSArray *places, NSError *error) {
        [self splitPlacesInSections:places];
        
        _placesTableView.dataSource = self;
        _placesTableView.delegate = self;
        
        [_placesTableView reloadData];
    }];
}

-(void)splitPlacesInSections:(NSArray*)places{
    NSMutableArray *lessThan5KM = [NSMutableArray array];
        NSMutableArray *lessThan20KM = [NSMutableArray array];
        NSMutableArray *moreThan20KM = [NSMutableArray array];
    for(PUPlace *p in places){
        if(p.distanceInKm < 5){
            [lessThan5KM addObject:p];
        }else if(p.distanceInKm > 5 && p.distanceInKm < 20){
            [lessThan20KM addObject:p];
        }else{
            [moreThan20KM addObject:p];
        }
    }
    _places = @[lessThan5KM,lessThan20KM,moreThan20KM];
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title = @"Places";
    [self fetchPlaces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"PlaceCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    PUPlace *place = [self placeAtIndexPath:indexPath];
    
    cell.textLabel.text = place.name;
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_places count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *places =  [_places objectAtIndex:section];
    return places.count;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *cellID = @"PUHeaderCellID";
    PUHeaderCell *cell = (PUHeaderCell*)[tableView dequeueReusableCellWithIdentifier:cellID];
    cell.message.text = [self headerMessageForSection:section];
    return cell;
}
-(PUPlace*)placeAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *places = [_places objectAtIndex:indexPath.section];
    return [places objectAtIndex:indexPath.row];
}
-(NSString*)headerMessageForSection:(NSInteger)section{
    if(section == LessThan5KM)
        return @"Menos de 5 Km";
    else if(section == LessThan20KM)
        return @"Menos de 20 Km";
    else
        return @"Mais de 20 Km";
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSArray *places =  [_places objectAtIndex:section];
    return places.count > 0 ? 44 : 0;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PUPlace *place = [_places objectAtIndex:indexPath.row];
    UITabBarController *tabController =  (UITabBarController*)self.parentViewController;
    [tabController setSelectedIndex:0];
    PUPartiesViewController *partiesController = (PUPartiesViewController*)tabController.selectedViewController;
    [partiesController fetchPartiesForPlace:place];
}


-(void)clearPlaces{
    _places = @[];
    [_placesTableView reloadData];
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_service fetchPlacesForQuery:searchBar.text completion:^(NSArray *places, NSError *error) {
        [self clearPlaces];
        [self splitPlacesInSections:places];
        [_placesTableView reloadData];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    for(PUSearchSuggestion *s in _suggestions)
        NSLog(@"searchBarTextDidBeginEditing Suggestion Kind : %@ and Suggestions:%@",s.kind,s.suggestions);
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{

}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *searchTerm = [NSString stringWithFormat:@"%@%@",searchBar.text,text];
    NSLog(@"SearchTerm: %@",searchTerm);
    return YES;
}

@end
