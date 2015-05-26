//
//  PUControllPartyCell.h
//  partyUp
//
//  Created by Erick Vicente on 26/02/15.
//  Copyright (c) 2015 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUParty.h"

@protocol PUControllPartyCellDelegate
@required - (void)presentViewController:(UIViewController *)viewControllerToPresent;
@end

@interface PUControllPartyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIAsyncButton *sendNamesButton;
@property (weak, nonatomic) id<PUControllPartyCellDelegate> delegate;

-(void)fillCell:(PUParty*)party andDelegate:(id<PUControllPartyCellDelegate>)delegate;

@end
