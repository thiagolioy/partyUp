//
//  PUPartyViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyViewController.h"
#import "PUPartyService.h"
#import "PUDownloader.h"
#import "PUPartyMoreInfoViewController.h"

@interface PUPartyViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *price;
@property (strong, nonatomic) IBOutlet UILabel *date;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *placeAddress;
@property (strong, nonatomic) IBOutlet UILabel *placeDistance;
@property (strong, nonatomic) IBOutlet UILabel *placeNeighborhood;
@property (strong, nonatomic) IBOutlet UILabel *placeState;
@property (strong, nonatomic) IBOutlet UIView *moreInfoView;


@property (strong, nonatomic) PUPartyService *service;
@property (strong, nonatomic) PUParty *party;
@end

@implementation PUPartyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUpPartyService];
    [self fetchParty];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setUpPartyService{
    _service = [PUPartyService new];
}

-(void)fetchParty{
    [_service fetchParty:_partyId completion:^(PUParty *party, NSError *error) {
        if(!error)
            [self fillPartyInfo:party];
    }];
}

-(void)fillPartyInfo:(PUParty*)party{
    _party = party;
    [self downloadPartyImage];
    [self fillPartyPrice];
    [self fillPartyDate];
    [self fillPartyAddress];
    [self shouldShowMoreInfoView];
}
-(void)shouldShowMoreInfoView{
    _moreInfoView.hidden = ![_party.partyDescription isValid];
}

-(void)fillPartyAddress{
    _placeDistance.text = [_party.place prettyDistanceInKM];
    _placeName.text = _party.place.name;
    _placeAddress.text = [_party.place prettyFormattedAddress];
    _placeNeighborhood.text = _party.place.neighborhood;
    _placeState.text = _party.place.state;
}
-(void)fillPartyPrice{
    _price.text = [_party prettyFormattedPrices];
}
-(void)fillPartyDate{
   _date.text = [_party prettyFormattedDate];
}

-(void)downloadPartyImage{
    [PUDownloader downloadImage:_party.promoImage
                     completion:^(UIImage *image, NSError *error) {
                         if(!error && image)
                             [_promoImage setImage:image];
    }];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([@"showPartyMoreInfo" isEqualToString:segue.identifier]){
        PUPartyMoreInfoViewController *dest = (PUPartyMoreInfoViewController*)[segue destinationViewController];
        [dest fillPartyInfo:_party];
    }
}

@end
