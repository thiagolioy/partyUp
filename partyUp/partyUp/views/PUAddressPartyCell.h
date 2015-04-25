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

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *distanceLabel;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *neighnorhoodLabel;
@property (strong, nonatomic) IBOutlet UILabel *stateLabel;

- (void) fillCell:(PUParty*)party;

@end
