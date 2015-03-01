//
//  PUAdressPartyCell.m
//  partyUp
//
//  Created by Erick Vicente on 26/02/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "PUAddressPartyCell.h"

@implementation PUAddressPartyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillCell:(PUParty *)party{
    _nameLabel.text = party.place.name;
    _distanceLabel.text = [party.place prettyDistanceInKM];
    _addressLabel.text = [party.place prettyFormattedAddress];
//    _neighnorhoodLabel.text = [party.place neighborhood];
//    _stateLabel.text = [party.place state];
}

@end
