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

@property (strong, nonatomic) IBOutlet UIImageView *promoImageView;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

- (void)fillCell:(PUParty*)party;

@end
