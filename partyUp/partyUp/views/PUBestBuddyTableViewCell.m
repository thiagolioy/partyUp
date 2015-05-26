//
//  PUBuddyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBestBuddyTableViewCell.h"

@interface PUBestBuddyTableViewCell ()

@property (weak, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) id<PUBestBuddyTableViewCellDelegate> delegate;
@property (strong, nonatomic) PUUser *buddy;

@end
static NSString *bestBuddiesCellID = @"BestBuddyCellID";

@implementation PUBestBuddyTableViewCell

+(NSString*)cellID{
    return bestBuddiesCellID;
}

-(void)fill:(PUUser*)buddy{
    _buddy = buddy;
    [_profilePicture roundIt:18.0f];
    _profilePicture.profileID = buddy.userId;
    _name.text =  buddy.name;
}

-(void)fill:(PUUser*)buddy withDelegate:(id<PUBestBuddyTableViewCellDelegate>)delegate{
    _delegate = delegate;
    [self fill:buddy];
}

-(IBAction)clickOnRemoveIcon:(id)sender{
    [[AnalyticsTriggerManager sharedManager] removeFriendFromEvent];
    if(_delegate)
        [_delegate removeBuddy:_buddy];
}

@end
