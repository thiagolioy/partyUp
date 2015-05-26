//
//  PUImagePartyCell.h
//  partyUp
//
//  Created by Erick Vicente on 26/02/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUParty.h"

@interface PUImagePartyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *promoImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

- (void)fillCell:(PUParty*)party;

@end
