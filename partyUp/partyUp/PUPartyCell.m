//
//  PUPartyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/21/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyCell.h"
#import "PUDownloader.h"

@interface PUPartyCell()
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *distanceInKm;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end

@implementation PUPartyCell

-(void)fill:(PUParty*)party{
    [PUDownloader downloadImage:party.promoImage completion:^(UIImage *image, NSError *error) {
        if(!error && image)
            [_promoImage setImage:image];
    }];
    _name.text = party.name;
    _placeName.text = party.place.name;
    _distanceInKm.text = [party.place prettyDistanceInKM];
    _date.text = [party prettyFormattedDate];
}



@end
