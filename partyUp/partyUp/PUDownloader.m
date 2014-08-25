//
//  PUDownloader.m
//  partyUp
//
//  Created by Thiago Lioy on 8/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUDownloader.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PUDownloader


+(void)downloadImage:(NSString*)url completion:(DownloadImageCompletion)completion{
    NSURL *imageURL = [NSURL URLWithString:url];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:imageURL options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if(!error && image)
            completion(image,nil);
        else
            completion(nil,error);
        
    }];
}

@end
