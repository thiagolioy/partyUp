//
//  PUPartyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/21/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyTableViewCell.h"
#import "PUDownloader.h"

@interface PUPartyTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end

@implementation PUPartyTableViewCell

-(void)fill:(PUParty*)party{
    [PUDownloader downloadImage:party.promoImage completion:^(UIImage *image, NSError *error) {
        if(!error && image)
            [_promoImage setImage:image];
    }];
    _name.text = party.name;
}
@end
