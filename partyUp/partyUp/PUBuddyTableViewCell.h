//
//  PUBuddyTableViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PUBuddyTableViewCellDelegate <NSObject>

-(void)addToBestBuddies:(NSString*)buddyId;

@end

@interface PUBuddyTableViewCell : UITableViewCell

-(void)fill:(NSDictionary*)buddy andDelegate:(id<PUBuddyTableViewCellDelegate>)delegate;
@end
