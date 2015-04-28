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
#import "PUInviteBuddyToListCell.h"

@interface PUBuddiesListViewController ()<UITableViewDataSource,UITableViewDelegate,PUBestBuddyTableViewCellDelegate,PUBuddyTableViewCellDelegate,UISearchBarDelegate,UITextFieldDelegate>
@property(nonatomic,strong)IBOutlet UITableView *buddiesTableView;
@property(nonatomic,strong)IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong)IBOutlet UISearchBar *searchBar;
@property(nonatomic,strong)IBOutlet UIButton *sendBuddiesButton;
@property(nonatomic,strong)IBOutlet UITextField *typeToAddFriendTextField;
@property(nonatomic,strong)NSMutableArray *buddies;
@property(nonatomic,strong)NSMutableArray *bestBuddies;
@property(nonatomic,strong)PUSocialService *service;
@property(nonatomic,strong)NSString *searchTerm;
@end

typedef NS_ENUM(NSUInteger, BuddiesSections) {
    bestBuddies,
    otherBuddies,
    numberOfSections
};

@implementation PUBuddiesListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpTapGesture];
    [self initSocialService];
    [self fetchBuddies];
    [self hideStatusBar];
    [self trackPage];
}

-(void)trackPage{
    [[AnalyticsTriggerManager sharedManager] openScreen:@"/friends"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)hideStatusBar{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
}

-(void)initSocialService{
    _service = [PUSocialService new];
}
-(void)initBuddiesArrays{
    if(!_buddies)
        _buddies = [NSMutableArray array];
    if(!_bestBuddies)
        _bestBuddies = [NSMutableArray array];
    [_bestBuddies addObjectsFromArray:[PUBuddiesStorage storedBuddies]];
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

-(BOOL)hasBestBuddies{
    return [self filteredBestBuddies].count == 0 ?  NO : YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == bestBuddies){
        return [self hasBestBuddies] ?  [self filteredBestBuddies].count : 1;
    }
    return [self filteredBuddies].count;
}

-(PUUser*)buddyAtIndexPath:(NSIndexPath*)indexPath{
    NSArray *buddies = [self buddiesForSection:indexPath.section];
    return [buddies objectAtIndex:indexPath.row];
}

-(NSArray*)buddiesForSection:(NSInteger)section{
    if(section == bestBuddies)
        return [self filteredBestBuddies];
    
    return [self filteredBuddies];
}

- (PUBuddyTableViewCell *)tableView:(UITableView *)tableView buddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBuddyTableViewCell *cell = (PUBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[PUBuddyTableViewCell cellID]];
   
    PUUser *buddy = [self buddyAtIndexPath:indexPath];
    [cell fill:buddy andDelegate:self];
    return cell;
}

- (PUBestBuddyTableViewCell *)tableView:(UITableView *)tableView bestBuddiesCellAtIndexPath:(NSIndexPath *)indexPath{
    PUBestBuddyTableViewCell *cell = (PUBestBuddyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[PUBestBuddyTableViewCell cellID]];
    
    PUUser *buddy = [self buddyAtIndexPath:indexPath];
    [cell fill:buddy withDelegate:self];
    return cell;
}

- (PUInviteBuddyToListCell *)tableView:(UITableView *)tableView inviteBuddyCellAtIndexPath:(NSIndexPath *)indexPath{
    PUInviteBuddyToListCell *cell = (PUInviteBuddyToListCell*)[tableView dequeueReusableCellWithIdentifier:[PUInviteBuddyToListCell cellID]];
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section == bestBuddies){
    
        if([self hasBestBuddies])
            return [self tableView:tableView bestBuddiesCellAtIndexPath:indexPath];
        else
            return [self tableView:tableView inviteBuddyCellAtIndexPath:indexPath];
    
    }else
        return [self tableView:tableView buddiesCellAtIndexPath:indexPath];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    PUHeaderTableViewCell *cell = (PUHeaderTableViewCell*)[tableView dequeueReusableCellWithIdentifier:[PUHeaderTableViewCell cellID]];
    if([self hasBestBuddies:section])
        cell.message.text = @"Na lista";
    else if([self hasBuddies:section])
        cell.message.text = @"Amigos";
    return [cell contentView];
}
-(BOOL)hasBestBuddies:(NSInteger)section{
    return (section == bestBuddies);
}
-(BOOL)hasBuddies:(NSInteger)section{
    return (section == otherBuddies && [self filteredBuddies].count > 0);
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
    [self dismissKeyboard];
    PUUser *buddy = [self findBuddy:b onList:_bestBuddies];
    [b.userId containsString:@"typed"] ?
        [_bestBuddies removeObject:buddy] : [self demoteToBuddies:buddy];
    
    [self refreshBuddiesList];
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
    [self dismissKeyboard];
    PUUser *buddy = [self findBuddy:b onList:_buddies];
    if(buddy){
        [self promoteToBestBuddies:buddy];
        [self refreshBuddiesList];
    }
}


-(void)refreshBuddiesList{
    [_buddiesTableView triggerReloadAnimation];
    [_buddiesTableView reloadData];
}

-(PUUser*)findBuddy:(PUUser*)buddy onList:(NSArray*)buddies{
    for(PUUser *b in buddies)
        if([PUUser areTheSame:buddy otherUser:b])
            return b;
    return nil;
}

-(IBAction)dismissBuddiesModal:(id)sender{
    [self dismissKeyboard];
   [[UIApplication sharedApplication] setStatusBarHidden:NO
                                           withAnimation:UIStatusBarAnimationFade];
    [self dismissViewControllerAnimated:YES completion:^{
        if(_block){
            if (sender == _sendBuddiesButton)
                _block(YES);
            else
                _block(NO);
        }
    }];
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    _searchBar.text = @"";
    _searchTerm = @"";
    [self refreshBuddiesList];
    [searchBar resignFirstResponder];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    _searchTerm = searchText;
    [self refreshBuddiesList];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}

-(NSArray*)filterList:(NSArray*)list by:(NSString*)query{
    if(!query || query.length == 0)
        return list;
    
    NSMutableArray *filteredList = [NSMutableArray array];
    for(PUUser *f in list){
        if([self match:f.name withQuery:query]){
            [filteredList addObject:f];
        }
    }
    return (NSArray*)filteredList;
}

-(BOOL)match:(NSString*)name withQuery:(NSString*)query{
    return ([name rangeOfString:query options:NSCaseInsensitiveSearch|
                                         NSDiacriticInsensitiveSearch|
                            NSAnchoredSearch].location != NSNotFound);
        
}

-(void)cleanSearch{
    _searchBar.text = @"";
    _searchTerm = @"";
}

-(NSArray*)filteredBuddies{
    return (NSArray*)[self filterList:_buddies by:_searchTerm];
}

-(NSArray*)filteredBestBuddies{
    return (NSArray*)[self filterList:_bestBuddies by:_searchTerm];
}


-(void)setUpTapGesture{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void) dismissKeyboard
{
    [self cleanSearch];
    [self refreshBuddiesList];
    [_searchBar resignFirstResponder];
    [_typeToAddFriendTextField resignFirstResponder];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self addTypedFriendToList:_typeToAddFriendTextField.text];
    [textField resignFirstResponder];
    return YES;
}

-(IBAction)addTypedFriendToBestFriendsList:(id)sender{
    [_typeToAddFriendTextField resignFirstResponder];
    [self addTypedFriendToList:_typeToAddFriendTextField.text];
}

-(void)addTypedFriendToList:(NSString*)friendName{
    _typeToAddFriendTextField.text = @"";
    [self dismissKeyboard];
    PUUser *friend = [PUUser new];
    friend.name = friendName;
    NSUInteger hash = [[friendName stringByReplacingOccurrencesOfString:@" " withString:@""] hash];
    friend.userId = [NSString stringWithFormat:@"typed%lu",(unsigned long)hash];
    
    [_bestBuddies addObject:friend];
    [PUBuddiesStorage storeBuddies:_bestBuddies];
    [self refreshBuddiesList];

}



@end
