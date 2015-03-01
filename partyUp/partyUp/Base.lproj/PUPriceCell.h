//
//  PUPriceCell.h
//  partyUp
//
//  Created by Thiago Lioy on 3/1/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUPriceCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
- (void)fillCell:(PUParty*)party;
@end
