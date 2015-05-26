//
//  PUPlaceCell.m
//  partyUp
//
//  Created by Thiago Lioy on 12/4/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPlaceCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PUPlaceCell ()
@property (weak, nonatomic) IBOutlet UIImageView *promoImage;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *distanceInKm;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *neighborhood;
@property (weak, nonatomic) IBOutlet UILabel *state;
@end

static NSString *placeCellID = @"placeCellID";

@implementation PUPlaceCell

+(NSString*)cellID{
    return placeCellID;
}

-(void)fill:(PUPlace *)place{
    [_promoImage sd_setImageWithURL:[NSURL URLWithString:place.image]
                   placeholderImage:[UIImage imageNamed:@"Image_placeholder"]];

    _placeName.text = place.name;
    _distanceInKm.text = [place prettyDistanceInKM];
    _address.text = [place prettyFormattedAddress];
    _neighborhood.text = place.neighborhood;
    _state.text = place.state;
}

@end
