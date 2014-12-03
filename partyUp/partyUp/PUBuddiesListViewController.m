//
//  PUBuddiesListViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/22/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBuddiesListViewController.h"
#import "PUBuddyTableViewCell.h"
#import "PUBestBuddyTableViewCell.h"
#import "PUHeaderTableViewCell.h"
#import "PUSocialService.h"
#import "PUBuddiesStorage.h"

@interface PUBuddiesListViewController ()<UITableViewDataSource,UITableViewDelegate,PUBestBuddyTableViewCellDelegate,PUBuddyTableViewCellDelegate>
@property(nonatomic,strong)IBOutlet UITableView *buddiesTableView;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong)NSMutableArray *buddies;
@property(nonatomic,strong)NSMutableArray *bestBuddies;
@property(nonatomic,strong)PUSocialService *service;
@end

typedef NS_ENUM(NSUInteger, BuddiesSections) {
    bestBuddies,
    otherBuddies,
    numberOfSections
};

static NSString *buddiesCellID = @"BuddyCellID";
static NSString *bestBuddiesCellID = @"BestBuddyCellID";
static NSString *headerCellID = @"HeaderCellID";

@implementation PUBuddiesListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initSocialService];
    [self fetchBuddies];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initSocialService{
    _service = [PUSocialService new];
}
-(void)initBuddiesArrays{
    if(!_buddies)
        _buddies = [NSMutableArray array];
    if(!_bestBuddies)
        _bestBuddies = [NSMutableArray array];
    
    [_bestBuddies addObjectsFromArray:[self sortBuddiesByName:[PUBuddiesStorage storedBuddies]]];
}

-(void)removeBestBuddiesOfBuddies{
    for(PUUser *b in _bestBuddies){
        PUUser *buddy =  [self findBuddy:b onList:_buddies];
        [_buddies removeObject:buddy];
    }
}

-(void)fetchBuddies{
    [self initBuddiesArrays];
    
    [_activityIndicator startAnimating];

    [_service fetchBuddies:^(NSArray *buddies, NSError *error) {
        [_activityIndicator stopAnimating];
        if(!error){
            [_buddies addObjectsFromArray:buddies];
            [self removeBestBuddiesOfBuddies];
            [self refreshBuddiesList];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return numberOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == bestBuddies)
        return _bestBuddies.count;
    
    return _buddies.count;
}

-(PUUser*)buddyAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *buddies = [self buddiesForSection:indexPath.section];
    return [buddies objectAtIndex:indexPath.row];
}

-(NSArray*)buddiesForSection:(NSInteger)section{
    if(section == bestBuddies)
        return (NSArray*)_bestBuddies;
    
    return (NSArray*)_buddies;
}

- (PUBuddyTableViewCell *)tableView:(UITableView *)tableView buddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBuddyTableViewCell *cell = (PUBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:buddiesCellID];
   
    PUUser *buddy = [self buddyAtIndexPath:indexPath];
    [cell fill:buddy andDelegate:self];
    return cell;
}

- (PUBestBuddyTableViewCell *)tableView:(UITableView *)tableView bestBuddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBestBuddyTableViewCell *cell = (PUBestBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:bestBuddiesCellID];
    
    PUUser *buddy = [self buddyAtIndexPath:indexPath];
    [cell fill:buddy withDelegate:self];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == bestBuddies)
        return [self tableView:tableView bestBuddiesCellAtIndexPath:indexPath];
    else
        return [self tableView:tableView buddiesCellAtIndexPath:indexPath];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PUHeaderTableViewCell *cell = (PUHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:headerCellID];
    if([self hasBestBuddies:section])
        cell.message.text = @"Na lista";
    else if([self hasBuddies:section])
        cell.message.text = @"Amigos";
    return [cell contentView];
}
-(BOOL)hasBestBuddies:(NSInteger)section{
    return (section == bestBuddies && _bestBuddies.count > 0);
}
-(BOOL)hasBuddies:(NSInteger)section{
    return (section == otherBuddies && _buddies.count > 0);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if([self hasBestBuddies:section])
        return 44.0f;
    else if([self hasBuddies:section])
        return 44.0f;
    return 0.0f;
}

#pragma mark - Cell Delegates
-(void)removeBuddy:(PUUser *)b{
    PUUser *buddy = [self findBuddy:b onList:_bestBuddies];
    if(buddy){
        [self demoteToBuddies:buddy];
        [self refreshBuddiesList];
    }
}


-(void)promoteToBestBuddies:(PUUser*)buddy{
    [self transferBuddy:buddy from:_buddies to:_bestBuddies];
    [PUBuddiesStorage storeBuddies:_bestBuddies];
}

-(void)demoteToBuddies:(PUUser*)buddy{
    [self transferBuddy:buddy from:_bestBuddies to:_buddies];
    [PUBuddiesStorage storeBuddies:_bestBuddies];
}

-(void)transferBuddy:(PUUser*)buddy from:(NSMutableArray*)fromList to:(NSMutableArray*)toList{
    [fromList removeObject:buddy];
    [toList addObject:buddy];
}

-(void)addToBestBuddies:(PUUser *)b{
    PUUser *buddy = [self findBuddy:b onList:_buddies];
    if(buddy){
        [self promoteToBestBuddies:buddy];
        [self refreshBuddiesList];
    }
}

-(void)refreshBuddiesList{
    [self sortBuddiesLists];
    [self addReloadAnimationTo:_buddiesTableView];
    [_buddiesTableView reloadData];
}

-(void)addReloadAnimationTo:(UITableView*)tableView{
    CATransition* swapAnimation = [CATransition animation];
    swapAnimation.type = kCATransitionFade;
    swapAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    swapAnimation.fillMode = kCAFillModeBoth;
    swapAnimation.duration = .6f;
    [tableView.layer addAnimation:swapAnimation forKey:@"UITableViewReloadDataAnimationKey"];
}

-(void)sortBuddiesLists{
    _buddies = [NSMutableArray arrayWithArray:[self sortBuddiesByName:(NSArray*)_buddies]];
    _bestBuddies = [NSMutableArray arrayWithArray:[self sortBuddiesByName:(NSArray*)_bestBuddies]];
}

-(NSArray*)sortBuddiesByName:(NSArray*)list{
    NSInteger options = NSCaseInsensitiveSearch
    | NSNumericSearch              // Numbers are compared using numeric value
    | NSDiacriticInsensitiveSearch // Ignores diacritics (â == á == a)
    | NSWidthInsensitiveSearch;
    
    //sort facebookFriendsArray using name
    return [NSMutableArray arrayWithArray:
                            [list sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSString *firstName = [(PUUser*)a name];
        NSString *secondName = [(PUUser*)b name];
        return [firstName compare:secondName options:options];
    }]];
}


-(PUUser*)findBuddy:(PUUser*)buddy onList:(NSArray*)buddies{
    for(PUUser *b in buddies)
        if([PUUser areTheSame:buddy otherUser:b])
            return b;
    return nil;
}

-(IBAction)dismissBuddiesModal:(id)sender{
   [[UIApplication sharedApplication] setStatusBarHidden:NO
                                           withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:^{

    }];
}



@end
