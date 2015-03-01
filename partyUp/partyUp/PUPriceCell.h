//
//  PUPriceCell.h
//  partyUp
//
//  Created by Erick Vicente on 01/03/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUParty.h"

@interface PUPriceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

-(void)fillCell:(PUParty*)party;
@end
