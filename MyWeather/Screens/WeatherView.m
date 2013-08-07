//
//  WeatherView.m
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "CityEntity.h"
#import "WeatherView.h"

@interface WeatherView()

@property (weak, nonatomic) IBOutlet UILabel *refreshTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *conditionLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempRangeLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *wetLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;

@property (strong, nonatomic) WeatherFeed *weatherFeed;

@end

@implementation WeatherView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc
{
    WPrintBaseLog;
}

- (void)loadViewWithWeatherOfCity:(CityEntity *)cityEntity refresh:(BOOL)refresh
{
    if (!_weatherFeed) {
        _weatherFeed = [[WeatherFeed alloc] init];
    }
    _weatherFeed.delegate = self;
    if (!refresh) {
        [self loadViewWithWeatherOfCity:cityEntity];
    } else {
        [self.indicator startAnimating];
        [_weatherFeed requestWithCityCode:cityEntity.cityCode];
    }
}

- (void)loadViewWithWeatherOfCity:(CityEntity *)cityEntity
{
    self.temperatureLabel.text = [NSString stringWithFormat:@"%@℃", cityEntity.temp];
    self.refreshTimeLabel.text = [NSString stringWithFormat:@"今天%@发布", cityEntity.time];
    self.windLabel.text = cityEntity.wind;
    self.wetLabel.text = [NSString stringWithFormat:@"湿度：%@", cityEntity.wet];
}

#pragma mark - weather feed delegate
- (void)loadWeatherSuccessForCity:(CityEntity *)city
{
    [self loadViewWithWeatherOfCity:city];
    [self.indicator stopAnimating];
}

- (void)loadWeatherFailedWithError:(NSError *)error
{
    [self.indicator stopAnimating];
}

@end
