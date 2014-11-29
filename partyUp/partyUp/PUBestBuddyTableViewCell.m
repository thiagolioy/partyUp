//
//  PUBuddyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUBestBuddyTableViewCell.h"

@implementation PUBestBuddyTableViewCell

-(void)fill:(NSDictionary*)buddy{
    [_profilePicture roundIt:20.0f];
    _profilePicture.profileID = [buddy objectForKey:@"id"];
    _name.text = [buddy objectForKey:@"name"];
}

@end
