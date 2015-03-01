//
//  PUPriceCell.m
//  partyUp
//
//  Created by Erick Vicente on 01/03/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "PUPriceCell.h"

@implementation PUPriceCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)fillCell:(PUParty *)party{
    _priceLabel.text = [party prettyFormattedPrices];
}

@end
