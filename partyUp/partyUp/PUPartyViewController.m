//
//  PUPartyViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyViewController.h"
#import "PUPartyMoreInfoViewController.h"

#import "PUImagePartyCell.h"
#import "PUAddressPartyCell.h"
#import "PUDetailPartyCell.h"
#import "PUControllPartyCell.h"
#import "PUPriceCell.h"

@interface PUPartyViewController () <UITableViewDataSource,UITableViewDelegate,PUControllPartyCellDelegate>
@property (strong, nonatomic) IBOutlet UITableView *partyTableView;

@end

typedef NS_ENUM(char , PaymentTableSection) {
    ImageSection,
    AdressSection,
    PriceSection,
    DetailSection,
    ControllSection,
    NumberOfSections
};

@implementation PUPartyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillNavigationBarWithPartyName];
    [self trackPage];}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)trackPage{
    NSString *msg = [NSString stringWithFormat:@"party/%@",_party.partyId];
    [[AnalyticsTriggerManager sharedManager] openScreen:msg];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return NumberOfSections;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case ImageSection:
            return [self imageCellForRowAtIndexPath:indexPath];
            break;
        
        case AdressSection:
            return [self addressCellForRowAtIndexPath:indexPath];
            break;
        case PriceSection:
            return [self priceCellForRowAtIndexPath:indexPath];
            break;
            
        case DetailSection:
            return [self detailCellForRowAtIndexPath:indexPath];
            break;
            
        case ControllSection:
            return [self controllCellForRowAtIndexPath:indexPath];
            break;
            
        default:
            return nil;
            break;
    }
}

-(PUImagePartyCell *)imageCellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString *imageCellIdentifier = @"ImageCell";
    PUImagePartyCell *cell = (PUImagePartyCell *)[_partyTableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
    [cell fillCell:_party];
    return cell;
}

-(PUPriceCell *)priceCellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString *priceIdentifier = @"PriceCell";
    PUPriceCell *cell = (PUPriceCell *)[_partyTableView dequeueReusableCellWithIdentifier:priceIdentifier];
//    [cell fillCell:_party];
    return cell;
}

-(PUAddressPartyCell *)addressCellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString *addressIdentifier = @"AddressCell";
    PUAddressPartyCell *cell = (PUAddressPartyCell *)[_partyTableView dequeueReusableCellWithIdentifier:addressIdentifier];
    [cell fillCell:_party];
    return cell;
}

-(PUDetailPartyCell *)detailCellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString *detailCellIdentifier = @"DetailCell";
    PUDetailPartyCell *cell = (PUDetailPartyCell *)[_partyTableView dequeueReusableCellWithIdentifier:detailCellIdentifier];
    return cell;
}

-(PUControllPartyCell *)controllCellForRowAtIndexPath:(NSIndexPath*) indexPath {
    static NSString *controllCellIdentifier = @"ControllCell";
    PUControllPartyCell *cell = (PUControllPartyCell *)[_partyTableView dequeueReusableCellWithIdentifier:controllCellIdentifier];
    [cell fillCell:_party andDelegate:self];
    return cell;
}

-(void)fillNavigationBarWithPartyName{
    self.title = _party.name;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"showPartyMoreInfo" isEqualToString:segue.identifier]){
        PUPartyMoreInfoViewController *dest = (PUPartyMoreInfoViewController*)[segue destinationViewController];
        dest.party = _party;
    }
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent{
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_partyTableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [_partyTableView reloadData];
}

@end
