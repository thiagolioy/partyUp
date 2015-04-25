//
//  PUHeaderTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUHeaderTableViewCell.h"

static NSString *headerCellID = @"HeaderCellID";

@implementation PUHeaderTableViewCell

+(NSString*)cellID{
    return headerCellID;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
