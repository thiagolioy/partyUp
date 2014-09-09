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

@interface PUPlacesViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) PUPlacesService *service;
@property(nonatomic,strong)NSMutableArray *places;

@property(nonatomic,strong)IBOutlet UITableView *placesTableView;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@end

@implementation PUPlacesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _service = [PUPlacesService new];
    _service.placesPerFetch = 10;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
