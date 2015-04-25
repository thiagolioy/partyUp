//
//  PUPartyMoreInfoViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 10/26/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyMoreInfoViewController.h"

@interface PUPartyMoreInfoViewController ()
@property(nonatomic,strong)IBOutlet UITextView *partyDescription;
@end

@implementation PUPartyMoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self fillPartyInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(void)fillPartyInfo{
    _partyDescription.text = _party.partyDescription;
    self.title = _party.name;
}


@end
