//
//  PUInviteBuddyToListCell.m
//  partyUp
//
//  Created by Thiago Lioy on 12/4/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUInviteBuddyToListCell.h"

static NSString *inviteBuddyToListCellID = @"PUInviteBuddyToListCellID";

@implementation PUInviteBuddyToListCell

+(NSString*)cellID{
    return inviteBuddyToListCellID;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
