//
//  PUHeaderTableViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 11/29/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUHeaderTableViewCell : UITableViewCell
+(NSString*)cellID;
@property(nonatomic,weak)IBOutlet UILabel *message;
@end
