//
//  PUPartiesViewController.h
//  partyUp
//
//  Created by Thiago Lioy on 8/20/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PUPlace.h"

@interface PUPartiesViewController : UIViewController
-(void)fetchPartiesForPlace:(PUPlace*)place;
@end
