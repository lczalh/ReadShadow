//
//  HybridNSURLProtocol.m
//  WKWebVIewHybridDemo
//
//  Created by shuoyu liu on 2017/1/16.
//  Copyright © 2017年 shuoyu liu. All rights reserved.
//

#import "HybridNSURLProtocol.h"
#import <UIKit/UIKit.h>
static NSString*const sourUrl  = @"https://m.baidu.com/static/index/plus/plus_logo.png";
static NSString*const sourIconUrl  = @"http://m.baidu.com/static/search/baiduapp_icon.png";
static NSString*const localUrl = @"http://mecrm.qa.medlinker.net/public/image?id=57026794&certType=workCertPicUrl&time=1484625241";

static NSString* const KHybridNSURLProtocolHKey = @"KHybridNSURLProtocol";
@interface HybridNSURLProtocol ()<NSURLSessionDelegate>
@property (nonnull,strong) NSURLSessionDataTask *task;

@end


@implementation HybridNSURLProtocol

+ (BOOL)canInitWithRequest:(NSURLRequest *)request
{
    NSLog(@"request.URL.absoluteString = %@",request.URL.absoluteString);
    NSString *scheme = [[request URL] scheme];
    if ( ([scheme caseInsensitiveCompare:@"http"]  == NSOrderedSame ||
          [scheme caseInsensitiveCompare:@"https"] == NSOrderedSame ))
    {
        //看看是否已经处理过了，防止无限循环
        if ([NSURLProtocol propertyForKey:KHybridNSURLProtocolHKey inRequest:request])
            return NO;
        return YES;
    }
    return NO;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    NSMutableURLRequest *mutableReqeust = [request mutableCopy];
    
    //request截取重定向
    if ([request.URL.absoluteString isEqualToString:sourUrl])
    {
        NSURL* url1 = [NSURL URLWithString:localUrl];
        mutableReqeust = [NSMutableURLRequest requestWithURL:url1];
    }
    NSString *requestUrl = request.URL.absoluteString;
    NSLog(@"拦截到请求地址：%@ --- %@", requestUrl, request.URL.pathExtension);
    // 拦截广告
    if ([requestUrl containsString:@"img.09mk.cn"]
        ||[requestUrl containsString:@"img.xiaohui2.cn"]
        ||[requestUrl containsString:@".xiaohui"]
        ||[requestUrl containsString:@".apple.com"]
        ||[requestUrl containsString:@"img2."]
        ||[requestUrl containsString:@"sysapr.cn"]
        ) {
        mutableReqeust = nil;
    } else if ([requestUrl.pathExtension hasPrefix:@"m3u8"] || [requestUrl.pathExtension hasPrefix:@"mp4"]) {
        NSLog(@"拦截到请求地址：%@ --- %@", requestUrl, request.URL.pathExtension);
       // [NSURLProtocol wk_unregisterScheme:@"https"];
     //   [NSURLProtocol wk_unregisterScheme:@"http"];
       // [NSURLProtocol unregisterClass:[HybridNSURLProtocol class]];
    //    UIViewController * vc = [self cz_topmostController:[UIApplication sharedApplication].delegate.window.rootViewController];
      //  NSLog(@"%@",[vc class]);
        //[CZCommon cz_topmostController];
        // [UIApplication sharedApplication].delegate.window.rootViewController
    }

    return mutableReqeust;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b
{
    return [super requestIsCacheEquivalent:a toRequest:b];
}

- (void)startLoading
{
    NSMutableURLRequest *mutableReqeust = [[self request] mutableCopy];
    //给我们处理过的请求设置一个标识符, 防止无限循环,
    [NSURLProtocol setProperty:@YES forKey:KHybridNSURLProtocolHKey inRequest:mutableReqeust];
    
    //这里最好加上缓存判断，加载本地离线文件， 这个直接简单的例子。
    if ([mutableReqeust.URL.absoluteString isEqualToString:sourIconUrl])
    {
            NSData* data = UIImagePNGRepresentation([UIImage imageNamed:@"medlinker"]);
            NSURLResponse* response = [[NSURLResponse alloc] initWithURL:self.request.URL MIMEType:@"image/png" expectedContentLength:data.length textEncodingName:nil];
            [self.client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
            [self.client URLProtocol:self didLoadData:data];
            [self.client URLProtocolDidFinishLoading:self];
    }
    else
    {
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:nil];
        self.task = [session dataTaskWithRequest:self.request];
        [self.task resume];
    }
}
- (void)stopLoading
{
    if (self.task != nil)
    {
        [self.task  cancel];
    }
}


- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(nullable NSError *)error {
    [self.client URLProtocolDidFinishLoading:self];
}

@end
