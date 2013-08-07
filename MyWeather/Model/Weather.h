//
//  Weather.h
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject

@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *temp;
@property (strong, nonatomic) NSString *wind;
@property (strong, nonatomic) NSString *wet;
@property (strong, nonatomic) NSString *time;
@property (strong, nonatomic) NSString *tempRange;
@property (strong, nonatomic) NSString *weather;

@end
