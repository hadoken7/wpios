//
//  WPTableViewHelper.m
//  news
//
//  Created by WangPeng on 14-2-17.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import "WPTableViewHelper.h"
#import "EGORefreshTableHeaderView.h"
#import "WPLoadMoreCell.h"

@interface WPTableViewHelper ()<EGORefreshTableHeaderDelegate,WPLoadMoreCellDelegate>
{
    BOOL _reloading;
    EGORefreshTableHeaderView *_refreshHeaderView;
}
@property(nonatomic,assign)id<WPTableViewHelperDelegate> delegate;
@end

@implementation WPTableViewHelper

- (void)dealloc
{
    [_loadMoreCell release];
    [super dealloc];
}

- (id)initWithDelegate:(id<WPTableViewHelperDelegate>)delegate tableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        _reloading = false;
        _refreshHeaderView = [[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - tableView.bounds.size.height, 320, tableView.bounds.size.height)] autorelease];
		_refreshHeaderView.delegate = self;
		[tableView addSubview:_refreshHeaderView];
        
        
        _loadMoreCell = [[WPLoadMoreCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        _loadMoreCell.selectionStyle = UITableViewCellSelectionStyleNone;
        _loadMoreCell.delegate = self;
//        [_loadMoreCell setHidden:YES];
        _canLoadMore = YES;
    }
    return self;
}

- (void)loadInfoDone:(UIScrollView *)scrollView
{
    if (_reloading) {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:scrollView];
    }
    [_loadMoreCell loadMoreCellDataSourceDidFinishedLoading:scrollView];
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
    if ([_delegate respondsToSelector:@selector(loadInfoWithBoolIsLoadMore:)]) {
        _isLoadMore = NO;
        [_delegate loadInfoWithBoolIsLoadMore:_isLoadMore];
        _reloading = YES;
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
    //是否正在下拉刷新
	return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
    //上次刷新日期
	return [NSDate date];
}


- (void)loadMoreCellDidTriggerRefresh:(WPLoadMoreCell*)view
{
    if (self.canLoadMore) {
        if ([_delegate respondsToSelector:@selector(loadInfoWithBoolIsLoadMore:)]) {
            _isLoadMore = YES;
            [_delegate loadInfoWithBoolIsLoadMore:_isLoadMore];
            _reloading = YES;
        }
    }
    
}

- (void)helperDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
}
- (void)helperDidEndDragging:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    [_loadMoreCell loadMoreCellDidEndDragging:scrollView];
}

- (void)loadMoreInfo
{
    [self loadMoreCellDidTriggerRefresh:_loadMoreCell];
    
    
}
@end
