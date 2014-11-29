//
//  PUBuddyTableViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PUBestBuddyTableViewCellDelegate <NSObject>

-(void)removeBuddy:(NSString*)buddyId;

@end

@interface PUBestBuddyTableViewCell : UITableViewCell

-(void)fill:(NSDictionary*)buddy withDelegate:(id<PUBestBuddyTableViewCellDelegate>)delegate;
@end
