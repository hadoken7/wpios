//
//  WPBaseClient.h
//  news
//
//  Created by WangPeng on 14-2-13.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "JSONKit.h"

@interface WPBaseClient : NSObject <ASIHTTPRequestDelegate>
//设置是否进行服务器异常验证，默认为YES
//@property (nonatomic, assign)       BOOL authoration;
//设置连接服务器超时时间，默认为30秒
@property (nonatomic, assign)       int timeOutSeconds;
//设置是否对请求的响应进行缓存，默认为不缓存
@property (nonatomic, assign)       BOOL cacheData;
//设置是否将请求加入队列中，队列中的请求顺序执行
@property (nonatomic, assign)       BOOL isSequence;

//初始化
- (id)initWithTarget:(id)delegate action:(SEL)action;
//停止
- (void)stopHttpRequest;
//Get方法
- (void)setHttpRequestGetWithUrl:(NSString *)urlStr;
//Put方法
- (void)setHttpRequestPutWithUrl:(NSString *)urlStr;
//扩展的Get方法，自动拼接参数
- (void)setHttpRequestGetWithUrl:(NSString *)urlStr params:(NSDictionary *)params;
//Post方法
- (void)setHttpRequestPostWithUrl:(NSString *)urlStr params:(NSDictionary*)params;
//子类覆盖该方法可以获取服务器实际返回
- (void)response:(NSString *)responseString;
@end
