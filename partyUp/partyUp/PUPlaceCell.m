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
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *distanceInKm;
@property (strong, nonatomic) IBOutlet UILabel *address;
@end

@implementation PUPlaceCell

-(void)fill:(PUPlace *)place{
//    [_promoImage sd_setImageWithURL:[NSURL URLWithString:place.image]
//                   placeholderImage:[UIImage imageNamed:@"Image_placeholder"]];

    _placeName.text = place.name;
    _distanceInKm.text = [place prettyDistanceInKM];
//    _address.text = [place prettyFormattedAddress];
}

@end
