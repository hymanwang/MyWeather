//
//  CityView.m
//  MyWeather
//
//  Created by Hyman Wang on 6/5/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "CityEntity.h"
#import "CityView.h"
#import "WeatherFeed.h"
#import "CityManager.h"
#import "UIView+Jiggle.h"

@interface CityView()<WeatherFeedDelegate>

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UILabel *tempLabel;
@property (weak, nonatomic) IBOutlet UILabel *synTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UITapGestureRecognizer *tapGestureRecognizer;

@property (strong, nonatomic) WeatherFeed *weatherFeed;
@property (strong, nonatomic) CityEntity *city;

- (IBAction)handleTapGesture:(id)sender;
- (IBAction)handleLongPressGesture:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;

@end

@implementation CityView

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
    self.delegate = nil;
    WPrintBaseLog;
}

- (CityEntity *)city
{
    return _city;
}

- (void)loadCityViewWith:(CityEntity *)city fresh:(BOOL)fresh
{
    self.city = city;
    self.cityLabel.text = city.cityName;
    [self loadViewWithWeatherOfCity:city];
}

- (void)loadCityWeather
{
    if (!_weatherFeed) {
        _weatherFeed = [[WeatherFeed alloc] init];
    }
    _weatherFeed.delegate = self;
    [self.indicator startAnimating];
    [_weatherFeed requestWithCityCode:self.city.cityCode];
}

- (void)loadViewWithWeatherOfCity:(CityEntity *)city
{
    self.weatherLabel.text = city.weatherCondition;
    self.tempLabel.text = [NSString stringWithFormat:@"%@℃", city.temp];
    self.synTimeLabel.text = [NSString stringWithFormat:@"%@ 发布", city.time];
}

#pragma mark - city view delegate
- (void)loadWeatherSuccessForCity:(CityEntity *)city
{
    [self loadViewWithWeatherOfCity:city];
    [self.indicator stopAnimating];
}

- (void)loadWeatherFailedWithError:(NSError *)error
{
    [self.indicator stopAnimating];
}

#pragma mark - gustures
- (IBAction)handleTapGesture:(id)sender
{
    if (!self.deleteButton.hidden) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(backToWeatherContentViewWithCity:)]) {
        [self.delegate backToWeatherContentViewWithCity:self.city];
    }
}

- (IBAction)handleLongPressGesture:(id)sender
{
    self.deleteButton.hidden = NO;
    if ([self.statusDelegate respondsToSelector:@selector(startJiggleForAllView)]) {
        [self.statusDelegate startJiggleForAllView];
    }
}

- (void)showDeleteButtonByJiggle:(BOOL)isJiggling
{
    [self.deleteButton setHidden:!isJiggling];
}

#pragma mark - actions
- (IBAction)deleteButtonClicked:(id)sender
{
    if ([self.statusDelegate respondsToSelector:@selector(deleteView:)]) {
        [self.statusDelegate deleteView:self];
    }
}

@end
