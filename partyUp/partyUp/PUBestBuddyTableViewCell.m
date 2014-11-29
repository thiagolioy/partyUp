//
//  PUBuddyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBestBuddyTableViewCell.h"

@interface PUBestBuddyTableViewCell ()

@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *name;

@property (strong, nonatomic) id<PUBestBuddyTableViewCellDelegate> delegate;
@property (strong, nonatomic) PUUser *buddy;

@end

@implementation PUBestBuddyTableViewCell
-(void)fill:(PUUser*)buddy{
    _buddy = buddy;
    [_profilePicture roundIt:20.0f];
    _profilePicture.profileID = buddy.userId;
    _name.text =  buddy.name;
}

-(void)fill:(PUUser*)buddy withDelegate:(id<PUBestBuddyTableViewCellDelegate>)delegate{
    _delegate = delegate;
    [self fill:buddy];
}

-(IBAction)clickOnRemoveIcon:(id)sender{
    if(_delegate)
        [_delegate removeBuddy:_buddy];
}

@end
