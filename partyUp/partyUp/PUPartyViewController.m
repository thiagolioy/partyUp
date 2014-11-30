//
//  PUPartyViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyViewController.h"
#import "PUDownloader.h"
#import "PUPartyMoreInfoViewController.h"
#import <MapKit/MapKit.h>
#import "PUSendMailHelper.h"
#import "PUSocialService.h"
#import "PUBuddiesStorage.h"


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

@property (strong, nonatomic) PUSocialService *service;

@end

@implementation PUPartyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fillNavigationBarWithPartyName];
    [self fillPartyInfo];
    [self initSocialService];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)initSocialService{
    _service = [PUSocialService new];
}

-(void)fillNavigationBarWithPartyName{
    self.title = _party.name;
}

-(void)fillPartyInfo{
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
        dest.party = _party;
    }
}
-(IBAction)sendNamesToParty{
    if(_party.isMailNamesList)
        [PUSendMailHelper sendNamesTo:_party];
    else if(_party.isFacebookNamesList)
        [self sendNamesToFacebookEvent];
}

-(void)sendNamesToFacebookEvent{
    NSString *eventId = _party.sendNamesTo;
    [_service attendToEvent:eventId completion:^(NSError *error) {
        if(!error){
            [_service postOnEventFeed:eventId message:[PUBuddiesStorage storedBuddiesAndMyselfAsMailBody]
                           completion:^(NSString *evId,NSString *postId, NSError *error) {
                if(!error){
                    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://events/%@/",evId]];
                    [[UIApplication sharedApplication] openURL:url];
                }
            }];
        }
    }];
}

-(IBAction)displayRouteToParty{

    MKMapItem *from = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_party.place.location.coordinate addressDictionary:nil];
    MKMapItem *to = [[MKMapItem alloc] initWithPlacemark:placemark];
    to.name = _party.name;
    [self displayRouteFrom:from to:to];
    
    
}

- (void)displayRouteFrom:(MKMapItem*)from to:(MKMapItem*)to {
    NSDictionary* options = @{
                              MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving
                              };
    [MKMapItem openMapsWithItems: @[from,to] launchOptions: options];

}

@end
