//
//  PUPartyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/21/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PUPartyCell()
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *placeName;
@property (strong, nonatomic) IBOutlet UILabel *distanceInKm;
@property (strong, nonatomic) IBOutlet UILabel *date;

@end

@implementation PUPartyCell

-(void)fill:(PUParty*)party{
    [_promoImage sd_setImageWithURL:[NSURL URLWithString:party.promoImage]
                   placeholderImage:[UIImage imageNamed:@"Image_placeholder"]];
    _name.text = party.name;
    _placeName.text = party.place.name;
    _distanceInKm.text = [party.place prettyDistanceInKM];
    _date.text = [party prettyFormattedDate];
}



@end
