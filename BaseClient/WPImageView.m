//
//  WPImageView.m
//  news
//
//  Created by WangPeng on 14-2-21.
//  Copyright (c) 2014年 WangPeng. All rights reserved.
//

#import "WPImageView.h"
#import "WPQueueClient.h"

#define kWPImageIdKey               @"kWPImageIdKey"

@interface WPImageView ()<NSURLConnectionDelegate>
{
    
}
@property(nonatomic,retain) NSMutableData       *data;
@property(nonatomic,retain) NSURLConnection     *connection;
@property(nonatomic,copy)   NSString            *imageId;
@property(nonatomic,copy)   NSString            *imageIdKey;
@property(nonatomic,strong) NSString            *imageType;
@property(nonatomic,strong) NSString			*filePath;

@end

@implementation WPImageView

- (void)dealloc
{
    if (_imageUrl) {
        [_imageUrl release];
        _imageUrl = nil;
    }
    self.image = nil;
    self.data = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageUrl:(NSString *)imageUrl
{
//    self.imageUrl = imageUrl;
    if (_imageUrl) {
        [_imageUrl release];
    }
    if (imageUrl) {
        _imageUrl = [[NSString alloc] initWithString:imageUrl];
    }
    [self processFullPathURL];
}

- (void)setImageId:(NSString *)anId {
	
    if (_imageId) {
        [_imageId release];
    }
    if (anId) {
        _imageId = [[NSString alloc] initWithString:anId];
    }
	
	NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    BOOL *isDirPtr = &isDir;
    BOOL ans = NO;
    if ([fm fileExistsAtPath:[self filePath] isDirectory:isDirPtr]) {
        if (isDir) {
            ans = NO;
        }
        else{
            ans = YES;
        }
    }
    
	if (ans) {
		// if we know the image extention, and we're not resuing the imageview in a cell, take advantage of iOS image caching
//		if ([_imageType length] && !isInResuableCell) {
//			self.image = [[UIImage alloc] initWithContentsOfFile:[self filePath]];
//		} else {
//			self.image = [UIImage imageWithContentsOfFile:[self filePath]];
//		}
//        self.image = [UIImage imageWithContentsOfFile:[self filePath]];
        self.image = [[[UIImage alloc] initWithContentsOfFile:[self filePath]] autorelease];
		[self setNeedsDisplay];
	} else {
		[self startDownImage];
	}
}

- (void)processFullPathURL {
	NSArray *pathParts = [_imageUrl componentsSeparatedByString:@"/"];
	NSString *filePart = [pathParts lastObject];
	NSArray *fileParts = [filePart componentsSeparatedByString:@"."];
	
	if ([fileParts count] == 2) {
		self.imageType = [fileParts objectAtIndex:1];
	}
	self.imageId = [fileParts objectAtIndex:0];
}

- (void)processQueryURL:(NSString*)query {
    
	// if the imageIdKey was not supplied, we can try a generic "imageId" key
	if (!_imageIdKey || [_imageIdKey length] == 0) {
		self.imageIdKey = kDefaultImageIdKey;
	}
	
	NSArray *queryParts = [query componentsSeparatedByString:@"&"];
	for (NSString *param in queryParts) {
		if ([param hasPrefix:[NSString stringWithFormat:@"%@=", _imageIdKey]]) {
			NSArray *paramParts = [param componentsSeparatedByString:@"="];
			if ([paramParts count] == 2) {
				self.imageId = [paramParts objectAtIndex:1];
			}
		}
	}
	// couldn't generate an imageId, so can't cache, so download every time
	if (!_imageId) {
		[self startDownImage];
	}
}

- (void)startDownImage
{
    if (_imageUrl && _imageUrl.length) {
        self.data = [NSMutableData data];
        NSURL *url = [NSURL URLWithString:_imageUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
        self.connection = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    }
}

- (void)connection:(NSURLConnection *)theConnection	didReceiveData:(NSData *)incrementalData {
    if (!_data) self.data = [NSMutableData data];
    [_data appendData:incrementalData];
}

- (void)connection:(NSURLConnection *)theConnection didFailWithError:(NSError *)error {
//    if ([_delegate respondsToSelector:@selector(imageDidLoadFailed:)]) {
//        [_delegate imageDidLoadFailed:self];
//    }
    self.data = nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)theConnection {
	self.connection = nil;
	if ([theConnection.currentRequest.URL.absoluteString isEqualToString:_imageUrl]) {
		self.image = [UIImage imageWithData:_data];;
		[self setNeedsLayout];
		if ([_imageId length] > 0) [_data writeToFile:[self filePath] atomically:TRUE];
	}
	self.data = nil;
}



- (NSString*)fileName {
    NSString * ans = @"";
	if (_imageId){
        ans = [NSString stringWithFormat:@"cache_%@%@%@", _imageId, ([_imageType length])? @"." : @"", _imageType];
    }
	return ans;
}

- (NSString*)filePath {
    
	if (!_filePath) {
		NSString *imageCachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
		self.filePath = [imageCachePath stringByAppendingPathComponent:[self fileName]];
	}
	return _filePath;
}


//在移出对图片的监视
- (void)prepareForReuse
{
//    self.delegate = nil;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
