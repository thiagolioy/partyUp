//
//  PUDownloader.h
//  partyUp
//
//  Created by Thiago Lioy on 8/25/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^DownloadImageCompletion)(UIImage *image, NSError *error);

@interface PUDownloader : NSObject
+(void)downloadImage:(NSString*)url completion:(DownloadImageCompletion)completion;
@end
