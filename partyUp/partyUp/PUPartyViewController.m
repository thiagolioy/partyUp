//
//  PUPartyViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyViewController.h"
#import "PartyService.h"
#import "PUDownloader.h"

@interface PUPartyViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) PartyService *service;
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
    _service = [PartyService new];
}

-(void)fetchParty{
    [_service fetchParty:_partyId completion:^(PUParty *party, NSError *error) {
        _name.text = party.name;
        [PUDownloader downloadImage:party.promoImage
                         completion:^(UIImage *image, NSError *error) {
            if(!error && image)
                [_promoImage setImage:image];
        }];
    }];
}

@end
