//
//  PUHeaderCell.h
//  partyUp
//
//  Created by Thiago Lioy on 9/16/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUHeaderCell : UICollectionReusableView
@property(nonatomic,weak)IBOutlet UILabel *message;
+(NSString*)cellID;
@end
