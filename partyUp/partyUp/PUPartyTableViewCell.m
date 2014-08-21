//
//  PUPartyTableViewCell.m
//  partyUp
//
//  Created by Thiago Lioy on 8/21/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PUPartyTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *name;

@end

@implementation PUPartyTableViewCell

-(void)fill:(NSDictionary*)dc{
    [self downloadImage:[dc valueForKey:@"promoImage"]];
    _name.text = [dc valueForKey:@"name"];
}

-(void)downloadImage:(NSString*)url{
    NSURL *imageURL = [NSURL URLWithString:url];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imageURL options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(image){
            [_promoImage setImage:image];
        }
    }];
}

@end
