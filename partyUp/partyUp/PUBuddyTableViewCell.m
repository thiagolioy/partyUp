//
//  PUBuddyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBuddyTableViewCell.h"

@interface PUBuddyTableViewCell ()
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) NSDictionary *buddy;
@property (strong, nonatomic) id<PUBuddyTableViewCellDelegate> delegate;
@end

@implementation PUBuddyTableViewCell

-(void)fill:(NSDictionary*)buddy andDelegate:(id<PUBuddyTableViewCellDelegate>)delegate{
    _delegate = delegate;
    _buddy = buddy;
    [_profilePicture roundIt:20.0f];
    _profilePicture.profileID = [buddy objectForKey:@"id"];
    _name.text = [buddy objectForKey:@"name"];
}

-(IBAction)addBuddy:(id)sender{
    if(_delegate){
        [_delegate addToBestBuddies:[_buddy objectForKey:@"id"]];
    }
}

@end
