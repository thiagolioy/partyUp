//
//  PUImagePartyCell.m
//  partyUp
//
//  Created by Erick Vicente on 26/02/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import "PUImagePartyCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PUImagePartyCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCell:(PUParty*)party{
    _dateLabel.text = [NSString stringWithFormat:@"Data: %@h",[party prettyFormattedDatetime]];
    [self downloadPartyImage:party];
}

-(void)downloadPartyImage:(PUParty*)party{
    [_promoImageView sd_setImageWithURL:[NSURL URLWithString:[party partyOrPlaceImageUrl]]
                   placeholderImage:[UIImage imageNamed:@"Image_placeholder"]];
}

@end
