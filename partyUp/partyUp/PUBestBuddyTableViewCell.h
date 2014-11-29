//
//  PUBuddyTableViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUUser.h"

@protocol PUBestBuddyTableViewCellDelegate <NSObject>

-(void)removeBuddy:(PUUser*)buddy;

@end

@interface PUBestBuddyTableViewCell : UITableViewCell

-(void)fill:(PUUser*)buddy withDelegate:(id<PUBestBuddyTableViewCellDelegate>)delegate;
@end
