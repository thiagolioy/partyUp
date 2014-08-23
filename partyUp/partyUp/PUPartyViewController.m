//
//  PUPartyViewController.m
//  partyUp
//
//  Created by Thiago Lioy on 8/23/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUPartyViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface PUPartyViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *promoImage;
@property (strong, nonatomic) IBOutlet UILabel *name;
@end

@implementation PUPartyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchParty];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)fetchParty{
    PFQuery *query = [PFQuery queryWithClassName:@"Party"];
    [query getObjectInBackgroundWithId:_partyId block:^(PFObject *party, NSError *error) {
        NSString *name =  party[@"name"];
        NSString *imageUrl =  party[@"promoImage"];
        
        _name.text = name;
        [self downloadImage:imageUrl];
        
    }];
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
