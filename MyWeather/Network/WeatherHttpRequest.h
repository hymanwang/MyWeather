//
//  WeatherHttpRequest.h
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherHttpResponseDelegate.h"

@interface WeatherHttpRequest : NSObject<NSURLConnectionDataDelegate>

@property (weak, nonatomic) id<WeatherHttpResponseDelegate> delegate;
@property (strong, nonatomic) NSMutableData *responseData;

- (id)initWithURL:(NSURL *)aURL;

+ (id)requestWithURL:(NSURL *)aURL;

@end
