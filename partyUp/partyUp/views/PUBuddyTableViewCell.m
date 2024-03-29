//
//  PUBuddyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBuddyTableViewCell.h"

@interface PUBuddyTableViewCell ()
@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) PUUser *buddy;
@property (weak, nonatomic) id<PUBuddyTableViewCellDelegate> delegate;
@end

static NSString *buddiesCellID = @"BuddyCellID";

@implementation PUBuddyTableViewCell

+(NSString*)cellID{
    return  buddiesCellID;
}

-(void)fill:(PUUser*)buddy{
    _buddy = buddy;
    [_profilePicture roundIt:18.0f];
    _profilePicture.profileID = buddy.userId;
    _name.text = buddy.name;
}
-(void)fill:(PUUser*)buddy andDelegate:(id<PUBuddyTableViewCellDelegate>)delegate{
    _delegate = delegate;
    [self fill:buddy];
}

-(IBAction)addBuddy:(id)sender{
    [[AnalyticsTriggerManager sharedManager] addFriendToEvent];
    if(_delegate){
        [_delegate addToBestBuddies:_buddy];
    }
}

@end
