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
@property (weak, nonatomic) IBOutlet UIImageView *promoImage;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *placeName;
@property (weak, nonatomic) IBOutlet UILabel *distanceInKm;
@property (weak, nonatomic) IBOutlet UILabel *date;

@end
static NSString *partyCellID = @"partyCellID";

@implementation PUPartyCell

+(NSString*)cellID{
    return partyCellID;
}

-(void)fill:(PUParty*)party{
    [_promoImage sd_setImageWithURL:[NSURL URLWithString:[party partyOrPlaceImageUrl]]
                   placeholderImage:[UIImage imageNamed:@"Image_placeholder"]];
    _name.text = party.name;
    _placeName.text = party.place.name;
    _distanceInKm.text = [party.place prettyDistanceInKM];
    _date.text = [party prettyFormattedDate];
}



@end
