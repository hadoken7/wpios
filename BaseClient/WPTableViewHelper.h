//
//  WPTableViewHelper.h
//  news
//
//  Created by WangPeng on 14-2-17.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WPLoadMoreCell.h"


@protocol WPTableViewHelperDelegate <NSObject>

- (void)loadInfoWithBoolIsLoadMore:(BOOL)isLoadMore;

@end

@interface WPTableViewHelper : NSObject

@property(nonatomic,assign)WPLoadMoreCell *loadMoreCell;
@property(nonatomic,assign)BOOL canLoadMore;
@property(nonatomic,assign)BOOL isLoadMore;

- (id)initWithDelegate:(id<WPTableViewHelperDelegate>)delegate tableView:(UITableView *)tableView;

- (void)loadInfoDone:(UIScrollView *)scrollView;

- (void)helperDidScroll:(UIScrollView *)scrollView;
- (void)helperDidEndDragging:(UIScrollView *)scrollView;

- (void)loadMoreInfo;

@end
