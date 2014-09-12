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

@interface PUPlacesViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic,strong) PUPlacesService *service;
@property(nonatomic,strong)NSMutableArray *places;

@property(nonatomic,strong)IBOutlet UITableView *placesTableView;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@end

@implementation PUPlacesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    _searchBar.delegate = self;
}

-(void)fetchPlaces{
    if(!_service)
        _service = [PUPlacesService new];
    
    _service.placesPerFetch = 50;
    [_service fetchPlacesNearMe:^(NSArray *places, NSError *error) {
        if(!_places)
            _places = [NSMutableArray array];
        [_places addObjectsFromArray:places];
        
        _placesTableView.dataSource = self;
        _placesTableView.delegate = self;
        
        [_placesTableView reloadData];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    self.parentViewController.navigationItem.title = @"Places";
    [self fetchPlaces];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _places.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"PlaceCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    PUPlace *place = [_places objectAtIndex:indexPath.row];
    
    cell.textLabel.text = place.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PUPlace *place = [_places objectAtIndex:indexPath.row];
    UITabBarController *tabController =  (UITabBarController*)self.parentViewController;
    [tabController setSelectedIndex:0];
    PUPartiesViewController *partiesController = (PUPartiesViewController*)tabController.selectedViewController;
    [partiesController fetchPartiesForPlace:place];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)clearPlaces{
    [_places removeAllObjects];
    [_placesTableView reloadData];
}

#pragma mark - UISearchBarDelegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    [_service fetchPlacesForQuery:searchBar.text completion:^(NSArray *places, NSError *error) {
        [self clearPlaces];
        [_places addObjectsFromArray:places];
        [_placesTableView reloadData];
    }];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar{
    [_searchBar resignFirstResponder];
}

@end
