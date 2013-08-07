//
//  CityManagementViewController.h
//  MyWeather
//
//  Created by Hyman Wang on 6/5/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherContentViewController.h"

@class CityEntity;
@protocol CityViewDelegate <NSObject>

- (void)backToWeatherContentViewWithCity:(CityEntity *)city;

@end

@class CityView;
@protocol CityViewStatusDelegate <NSObject>

- (void)startJiggleForAllView;
- (void)deleteView:(CityView *)cityView;

@end

@interface CityManagementViewController : UIViewController<CityViewDelegate, CityViewStatusDelegate>

@property (assign, nonatomic) id<CityListChangedDelegate> delegate;

- (void)addNewCityWithCityName:(NSString *)cityName cityCode:(NSString *)cityCode;

@end
