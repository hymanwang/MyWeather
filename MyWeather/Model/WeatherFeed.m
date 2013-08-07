//
//  WeatherFeed.m
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "WeatherFeed.h"
#import "CityManager.h"
#import "CityEntity.h"
#import "WeatherHttpRequest.h"

#define WEATHERAPI @"http://www.weather.com.cn/data/sk/%@.html"

@implementation WeatherFeed

- (void)requestWithCityCode:(NSString *)cityCode
{
    NSURL *weatherURL = [NSURL URLWithString:[NSString stringWithFormat:WEATHERAPI, cityCode]];
    self.cityCode = cityCode;
    WeatherHttpRequest *request = [[WeatherHttpRequest alloc] initWithURL:weatherURL];
    WDebugLog(@"Send request to: %@", weatherURL);
    [request setDelegate:self];
    self.cityManager = [CityManager sharedCityManeger];
}

- (void)parseWeatherDate:(NSData *)responseData
{
    NSError *error;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:responseData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:&error];
    [self parseWeatherFeed:dictionary];

    if ([self.delegate respondsToSelector:@selector(loadWeatherSuccessForCity:)])
        [self.delegate loadWeatherSuccessForCity:_city];
}

- (void)parseWeatherFeed:(NSDictionary *)weatherFeed
{
    if (!self.city) {
        self.city = [[self.cityManager queryCityWithCityCode:self.cityCode] objectAtIndex:0];
    }
    
    NSDictionary *weatherInfo = [weatherFeed objectForKey:@"weatherinfo"];
    self.city.temp = [weatherInfo objectForKey:@"temp"];
    self.city.time = [weatherInfo objectForKey:@"time"];
    self.city.wind = [NSString stringWithFormat:@"%@ %@", [weatherInfo objectForKey:@"WD"], [weatherInfo objectForKey:@"WS"]];
    self.city.wet = [weatherInfo objectForKey:@"SD"];
    [self.cityManager updateWithCity:self.city];
}

- (void)connectionFinishWithResponseData:(NSData *)responseData
{
    [self parseWeatherDate:responseData];
}

- (void)connectionFailWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(loadWeatherFailedWithError:)]) {
        [self.delegate loadWeatherFailedWithError:error];
    }
}

@end
