//
//  WPQueueClient.h
//  news
//
//  Created by WangPeng on 14-2-14.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASINetworkQueue.h"

@interface WPQueueClient : NSObject

+ (WPQueueClient *)sharedQueue;
- (void)addClient:(ASIHTTPRequest *)request;
- (void)stopAllClient;

@end
