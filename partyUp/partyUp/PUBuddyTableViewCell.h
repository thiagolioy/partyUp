//
//  PUBuddyTableViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUBuddyTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePicture;
@property (strong, nonatomic) IBOutlet UILabel *name;
-(void)fill:(NSDictionary*)buddy;
@end
