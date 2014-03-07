//
//  WPLoadMoreCell.m
//  news
//
//  Created by WangPeng on 14-2-17.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import "WPLoadMoreCell.h"


@interface WPLoadMoreCell ()
{
    BOOL _loading;
}

@end

@implementation WPLoadMoreCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _pushUpDistance = 60;
        self.titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 30)] autorelease];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = RGB(140, 140, 140);
        [self.contentView addSubview:_titleLabel];
        [self endLoading];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}


- (void)loadMoreCellDidEndDragging:(UIScrollView *)scrollView
{
	if ((scrollView.contentOffset.y + scrollView.frame.size.height - scrollView.contentSize.height)>= _pushUpDistance && !_loading) {
        if ([_delegate respondsToSelector:@selector(loadMoreCellDidTriggerRefresh:)]) {
			[_delegate loadMoreCellDidTriggerRefresh:self];
            [self startLoading];
		}
	}
}

- (void)loadMoreCellDataSourceDidFinishedLoading:(UIScrollView *)scrollView
{
    [self endLoading];
}

- (void)startLoading
{
    _loading = YES;
    _titleLabel.text = @"加载中...";
}

- (void)endLoading
{
    _loading = NO;
    _titleLabel.text = @"加载更多";
}
@end
