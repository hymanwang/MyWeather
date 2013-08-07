//
//  WeatherFeed.h
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherHttpResponseDelegate.h"

@class CityEntity;
@protocol WeatherFeedDelegate <NSObject>

@optional

- (void)loadWeatherSuccessForCity:(CityEntity *)city;
- (void)loadWeatherFailedWithError:(NSError *)error;

@end

@class CityManager;
@interface WeatherFeed : NSObject<WeatherHttpResponseDelegate>

@property (weak, nonatomic) id<WeatherFeedDelegate> delegate;
@property (strong, nonatomic) CityEntity *city;
@property (strong, nonatomic) NSString *cityCode;
@property (strong, nonatomic) CityManager *cityManager;

- (void)requestWithCityCode:(NSString *)cityCode;

@end
