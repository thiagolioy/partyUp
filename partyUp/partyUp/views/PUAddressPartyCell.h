//
//  PUAdressPartyCell.h
//  partyUp
//
//  Created by Erick Vicente on 26/02/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUParty.h"

@interface PUAddressPartyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

- (void) fillCell:(PUParty*)party;

@end
