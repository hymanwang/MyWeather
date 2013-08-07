//
//  WeatherHttpRequest.m
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "WeatherHttpRequest.h"

@implementation WeatherHttpRequest

+ (id)requestWithURL:(NSURL *)aURL
{
    return [[WeatherHttpRequest alloc] initWithURL:aURL];;
}

- (id)initWithURL:(NSURL *)aURL
{
    self = [super init];
    if (self) {
        [self startRequestWithURL:aURL];
    }
    return self;
}

- (void)startRequestWithURL:(NSURL *)url
{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLConnection *connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [connection start];
}

- (void)dealloc
{
    _delegate = nil;
    WPrintBaseLog;
}

- (void)setDelegate:(id<WeatherHttpResponseDelegate>)delegate
{
    _delegate = delegate;
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    if (!self.responseData) {
        self.responseData = [[NSMutableData alloc] init];
    }
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(connectionFailWithError:)]) {
        [self.delegate connectionFailWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if ([self.delegate respondsToSelector:@selector(connectionFinishWithResponseData:)]) {
        [self.delegate connectionFinishWithResponseData:self.responseData];
    }
}
@end
