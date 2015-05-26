//
//  PUControllPartyCell.m
//  partyUp
//
//  Created by Erick Vicente on 26/02/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "PUControllPartyCell.h"

#import "PUBuddiesListViewController.h"
#import "PUSendMailHelper.h"
#import "PUSocialService.h"
#import "PUPushNotificationManager.h"
#import "PUBuddiesStorage.h"

#import <MapKit/MapKit.h>

@interface PUControllPartyCell ()
@property (strong,nonatomic) PUParty *party;
@property (strong, nonatomic) PUSocialService *service;
@property (strong, nonatomic) IBOutlet UIView *sendNamesContainerView;
@end

@implementation PUControllPartyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillCell:(PUParty*)party andDelegate:(id<PUControllPartyCellDelegate>)delegate{
    _party = party;
    _delegate = delegate;

    [self shouldShowSendNamesButton];
    [self initSocialService];
}

-(void)shouldShowSendNamesButton{
    NSString *listType = _party.sendNamesType;
    if([listType isEqualToString:@"facebook"] || [listType isEqualToString:@"mail"])
        _sendNamesContainerView.hidden = NO;
    else
        _sendNamesContainerView.hidden = YES;
}

-(void)initSocialService{
    _service = [PUSocialService new];
}

-(IBAction)sendNamesToParty{
    [[AnalyticsTriggerManager sharedManager] sendNamesEvent];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    PUBuddiesListViewController *buddiesVC = [storyboard instantiateViewControllerWithIdentifier:@"PUBuddiesListViewController"];
    
    buddiesVC.block = ^(BOOL needSave){
        [_sendNamesButton showLoader];
        if (!needSave) {
            [_sendNamesButton reset];
        }else{
            if(_party.isMailNamesList){
                [_sendNamesButton reset];
                [self notifyBuddies];
                [PUSendMailHelper sendNamesTo:_party];
            }else if(_party.isFacebookNamesList)
                [self sendNamesToFacebookEvent];
        }
    };
    
    if (_delegate)
       [_delegate presentViewController:buddiesVC];
}

-(void)sendNamesToFacebookEvent{
    NSString *eventId = _party.sendNamesTo;
    [self postOnEventFeed:eventId];
}

-(void)attendToFacebookEvent:(NSString*)eventId{
    [_service attendToEvent:eventId completion:^(NSError *error) {
        if(!error){
            [self postOnEventFeed:eventId];
        }else{
            [_sendNamesButton reset];
            [PUAlertUtil showAlertWithMessage:@"Ocorreu um erro ao confirmar presença no evento!"];
        }
        
    }];
}

-(void)notifyBuddies{
    NSArray *buddies = [PUBuddiesStorage storedBuddies];
    for(PUUser *buddy in buddies)
        [PUPushNotificationManager notifyFriend:buddy.userId addedToEvent:_party.name];
}

-(void)postOnEventFeed:(NSString*)eventId{
    [_service postOnEventFeed:eventId message:[PUBuddiesStorage storedBuddiesAndMyselfAsMailBody]
                   completion:^(NSString *evId,NSString *postId, NSError *error) {
                       
                       [_sendNamesButton reset];
                       if(!error){
                           [self notifyBuddies];
                           [self showEventFeedOnFacebookApp:evId];
                       }else{
                           [self attendToFacebookEvent:eventId];
                       }
                       
                   }];
}

-(void)showEventFeedOnFacebookApp:(NSString*)eventId{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://profile/%@/",eventId]];
    [[UIApplication sharedApplication] openURL:url];
}

-(IBAction)displayRouteToParty{
    [[AnalyticsTriggerManager sharedManager] findOutRouteToEvent];
    MKMapItem *from = [MKMapItem mapItemForCurrentLocation];
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:_party.place.clLocation.coordinate addressDictionary:nil];
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
