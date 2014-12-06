//
//  PUPlaceCell.h
//  partyUp
//
//  Created by Thiago Lioy on 12/4/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUPlace.h"

@interface PUPlaceCell : UICollectionViewCell

+(NSString*)cellID;
-(void)fill:(PUPlace*)place;
@end
