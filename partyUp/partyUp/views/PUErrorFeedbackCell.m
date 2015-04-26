//
//  PUErrorFeedbackCell.m
//  partyUp
//
//  Created by Thiago Lioy on 12/7/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUErrorFeedbackCell.h"

static NSString *errorFeedbackCellID = @"errorFeedbackCellID";

@implementation PUErrorFeedbackCell

+(CGSize)cellSize{
    return CGSizeMake(320, 400);
}
+(NSString*)cellID{
    return errorFeedbackCellID;
}
@end
