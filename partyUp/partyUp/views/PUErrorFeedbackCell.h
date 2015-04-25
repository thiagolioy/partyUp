//
//  PUErrorFeedbackCell.h
//  partyUp
//
//  Created by Thiago Lioy on 12/7/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PUErrorFeedbackCell : UICollectionViewCell
@property(nonatomic,weak)IBOutlet UILabel *errorMsg;
+(CGSize)cellSize;
+(NSString*)cellID;
@end
