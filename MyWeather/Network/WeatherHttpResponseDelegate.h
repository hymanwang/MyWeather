//
//  WeatherHttpResponseDelegate.h
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WeatherHttpResponseDelegate <NSObject>

@optional
- (void)connectionFailWithError:(NSError *)error;
- (void)connectionFinishWithResponseData:(NSData *)responseData;

@end
