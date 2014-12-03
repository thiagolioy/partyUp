//
//  PUBuddiesListViewController.h
//  partyUp
//
//  Created by Thiago Lioy on 8/22/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^AfterSelectFriends)(void);

@interface PUBuddiesListViewController : UIViewController
@property (nonatomic, copy) AfterSelectFriends block;
@end
