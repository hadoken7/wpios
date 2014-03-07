//
//  WPLoadMoreCell.h
//  news
//
//  Created by WangPeng on 14-2-17.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WPLoadMoreCell;

@protocol WPLoadMoreCellDelegate <NSObject>

- (void)loadMoreCellDidTriggerRefresh:(WPLoadMoreCell*)view;

@end

@interface WPLoadMoreCell : UITableViewCell


@property (nonatomic, assign) UILabel *titleLabel;
@property (nonatomic, assign) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, copy) NSString *tempStr;
@property (nonatomic, assign) id<WPLoadMoreCellDelegate> delegate;
//定义上拉刷新的距离
@property (nonatomic, assign) int pushUpDistance;

//在UIScrollView的delegate中调用
- (void)loadMoreCellDidEndDragging:(UIScrollView *)scrollView;
//结束加载更多后调用
- (void)loadMoreCellDataSourceDidFinishedLoading:(UIScrollView *)scrollView;
//用于点击cell时调用
- (void)startLoading;

@end
