//
//  WPBaseClient.m
//  news
//
//  Created by WangPeng on 14-2-13.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import "WPBaseClient.h"
#import "JSONKit.h"


@interface WPBaseClient ()
{
    SEL         _action;
    id          _delegate;
    
    //Request
    ASIHTTPRequest *_request;
    ASIFormDataRequest *_dataRequest;
    
}
@property(nonatomic,retain)NSMutableData *resultData;

@end

@implementation WPBaseClient

- (void)dealloc
{
    [super dealloc];
}


- (id)initWithTarget:(id)delegate action:(SEL)action
{
    self = [super init];
    if (self) {
        _delegate = delegate;
        _action = action;
        _dataRequest = nil;
        _request = nil;
        self.resultData = nil;
        _timeOutSeconds = 30;
        [self retain];
    }
    return self;
}

- (void)stopHttpRequest
{
    if (_request) {
        [_request clearDelegatesAndCancel];
        [self requestFinished:_request];
    }
    if (_dataRequest) {
        [_dataRequest clearDelegatesAndCancel];
        [self requestFinished:_dataRequest];
    }
    
}

- (void)loadFormDataRequestWithUrl:(NSString *)urlStr requestMethod:(NSString *) method
{
    NSURL * url = [NSURL URLWithString:urlStr];
    _dataRequest = [ASIFormDataRequest requestWithURL:url];
    [_dataRequest setRequestMethod:method];//设置传输
    //text/javascript; charset=utf-8
    [_dataRequest addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
    [_dataRequest addRequestHeader:@"Accept" value:@"application/json"];
    [_dataRequest setDelegate:self];
    [_dataRequest setTimeOutSeconds:_timeOutSeconds];
}
- (void)setHttpRequestPutWithUrl:(NSString *)urlStr
{
    [self loadFormDataRequestWithUrl:urlStr requestMethod:@"PUT"];
    [_dataRequest startAsynchronous];
}
- (void)setHttpRequestGetWithUrl:(NSString *)urlStr
{
    [self loadFormDataRequestWithUrl:urlStr requestMethod:@"GET"];
    [_dataRequest startAsynchronous];
}

- (void)setHttpRequestGetWithUrl:(NSString *)urlStr params:(NSDictionary *)params
{
    [self loadFormDataRequestWithUrl:urlStr requestMethod:@"GET"];
    [self setDataRequestWithDict:params];
    [_dataRequest startAsynchronous];
}

- (void)setHttpRequestPostWithUrl:(NSString *)urlStr params:(NSDictionary*)params
{
    [self loadFormDataRequestWithUrl:urlStr requestMethod:@"POST"];
    [self setDataRequestWithDict:params];
    [_dataRequest startAsynchronous];
}

- (void)setDataRequestWithDict:(NSDictionary *)dict
{
    NSArray * keys = [dict allKeys];
    for (NSString * key in keys) {
        NSString * obj = (NSString *) [dict objectForKey:key];
        [_dataRequest setPostValue:obj forKey:key];
        CLog(@"%@  , %@", obj,key);
    }
}




- (void)response:(NSString *)responseString
{
    
}


// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
- (void)requestStarted:(ASIHTTPRequest *)request
{
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    JSONDecoder *jd=[[JSONDecoder alloc] init];
    
    //针对NSData数据
//    NSData *data = [_resultData JSONData];
    NSData *data = [NSData dataWithData:_resultData];
    id ret = [jd objectWithData: data];
    NSString * string = [[[NSString alloc] initWithData:_resultData encoding:NSASCIIStringEncoding] autorelease];
    [self response:string];
    if ([_delegate respondsToSelector:_action]) {
        [_delegate performSelector:_action withObject:self withObject:ret];
    }
    [self release];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}

- (void)requestRedirected:(ASIHTTPRequest *)request
{
    
}

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector
- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    if (!_resultData) {
        self.resultData = [NSMutableData data];
    }
    [_resultData appendData:data];
}

// If a delegate implements one of these, it will be asked to supply credentials when none are available
// The delegate can then either restart the request ([request retryUsingSuppliedCredentials]) once credentials have been set
// or cancel it ([request cancelAuthentication])
- (void)authenticationNeededForRequest:(ASIHTTPRequest *)request
{
    
}
- (void)proxyAuthenticationNeededForRequest:(ASIHTTPRequest *)request
{
    
}

@end
