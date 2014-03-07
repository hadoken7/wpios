//
//  WPImageView.h
//  news
//
//  Created by WangPeng on 14-2-21.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WPImageDelegate.h"

@interface WPImageView : UIImageView


//@property (nonatomic, assign) id<WPImageDelegate> delegate;
@property(nonatomic,copy)NSString *imageUrl;
//@property(nonatomic,retain)UIImage *image;

//在移出对图片的监视
//- (void)prepareForReuse;


@end
