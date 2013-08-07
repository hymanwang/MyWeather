//
//  WeatherContentViewController.h
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"

@class CityEntity;
@protocol CityListChangedDelegate <NSObject>

- (void)addNewCityToWeatherContentView:(CityEntity *)city;
- (void)removeCityFromWeatherContentView:(CityEntity *)city;
- (void)moveToSelectedCity:(CityEntity *)city;

@end


@interface WeatherContentViewController : UIViewController<CityListChangedDelegate, UIScrollViewDelegate, SinaWeiboDelegate, SinaWeiboRequestDelegate>


@end

