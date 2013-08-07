//
//  WeatherView.h
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherFeed.h"

@class CityEntity;
@interface WeatherView : UIView<WeatherFeedDelegate>

- (void)loadViewWithWeatherOfCity:(CityEntity *)city refresh:(BOOL)refresh;

@end
