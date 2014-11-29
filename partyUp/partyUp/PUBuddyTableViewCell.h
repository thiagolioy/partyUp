//
//  PUBuddyTableViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUUser.h"

@protocol PUBuddyTableViewCellDelegate <NSObject>

-(void)addToBestBuddies:(PUUser*)buddy;

@end

@interface PUBuddyTableViewCell : UITableViewCell
-(void)fill:(PUUser*)buddy;
-(void)fill:(PUUser*)buddy andDelegate:(id<PUBuddyTableViewCellDelegate>)delegate;
@end
