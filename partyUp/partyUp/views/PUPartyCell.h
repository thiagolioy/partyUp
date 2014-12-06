//
//  PUPartyTableViewCell.h
//  partyUp
//
//  Created by Thiago Lioy on 8/21/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUParty.h"

@interface PUPartyCell : UICollectionViewCell

+(NSString*)cellID;
-(void)fill:(PUParty*)party;
@end
