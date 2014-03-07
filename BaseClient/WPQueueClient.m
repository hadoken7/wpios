//
//  WPQueueClient.m
//  news
//
//  Created by WangPeng on 14-2-14.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import "WPQueueClient.h"

@interface WPQueueClient ()
{
    ASINetworkQueue *_networkQueue;
}

@end


static WPQueueClient * _sharedInstance = nil;

@implementation WPQueueClient




+ (WPQueueClient *)sharedQueue
{
    if (!_sharedInstance) {
        _sharedInstance = [[WPQueueClient alloc] init];
    }
    return _sharedInstance;
}

- (void)addClient:(ASIHTTPRequest *)request
{
    
}

- (void)stopAllClient
{
    
}

@end
