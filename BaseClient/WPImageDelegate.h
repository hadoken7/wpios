//
//  WPImageDelegate.h
//  news
//
//  Created by WangPeng on 14-2-21.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WPImageDelegate <NSObject>

@optional
//加载图片后返回图片大小
- (void)imageDidLoadWithSize:(CGSize)size sender:(id)sender isDefault:(BOOL)isDefault;
//图片下载失败
- (void)imageDidLoadFailed:(id)sender;


@end
