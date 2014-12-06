//
//  PUSearchCell.h
//  partyUp
//
//  Created by Thiago Lioy on 12/5/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PUSearchCellDelegate <NSObject>

-(void)search:(NSString*)query;

@end

@interface PUSearchCell : UICollectionViewCell
@property(nonatomic,weak)IBOutlet UISearchBar *searchBar;
@property(nonatomic,weak)id<PUSearchCellDelegate> delegate;

-(void)config:(id<PUSearchCellDelegate>)delegate;
-(void)resignSearchBar;
-(void)requestFocus;

+(NSString*)cellID;
@end
