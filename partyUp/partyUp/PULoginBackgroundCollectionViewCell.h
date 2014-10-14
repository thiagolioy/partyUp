//
//  PULoginBackgroundCollectionViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 10/13/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PULoginBackgroundCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak) IBOutlet UIImageView *backgroundImage;
@property(nonatomic,weak) IBOutlet UILabel *titleMessage;
@property(nonatomic,weak) IBOutlet UILabel *contentMessage;
@end
