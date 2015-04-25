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

-(void)setPlaceholderText:(NSString*)text{
    _searchBar.text = @"";
    _searchBar.placeholder = text;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [_searchBar setShowsCancelButton:NO animated:YES];
    [self resignSearchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *query = searchBar.text;
    [_searchBar setShowsCancelButton:NO animated:YES];
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
