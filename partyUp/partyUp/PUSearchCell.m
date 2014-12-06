//
//  PUSearchCell.m
//  partyUp
//
//  Created by Thiago Lioy on 12/5/14.
//  Copyright (c) 2014 Thiago Lioy. All rights reserved.
//

#import "PUSearchCell.h"

@interface PUSearchCell ()<UISearchBarDelegate>

@end
static NSString *searchCellID = @"searchCellID";

@implementation PUSearchCell

+(NSString*)cellID{
    return searchCellID;
}

-(void)config:(id<PUSearchCellDelegate>)delegate{
    _delegate = delegate;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *query = searchBar.text;
    [self resignSearchBar];
    if(_delegate)
        [_delegate search:query];
}

-(void)resignSearchBar{
    [_searchBar resignFirstResponder];
}

-(void)requestFocus{
    [_searchBar becomeFirstResponder];
}
@end
