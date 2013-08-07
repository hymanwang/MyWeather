//
//  WeatherEntity.h
//  MyWeather
//
//  Created by Hyman Wang on 6/8/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WeatherEntity : NSManagedObject

@property (nonatomic, retain) NSString * temp;
@property (nonatomic, retain) NSString * wind;
@property (nonatomic, retain) NSString * wet;
@property (nonatomic, retain) NSString * time;
@property (nonatomic, retain) NSString * tempRange;
@property (nonatomic, retain) NSString * weatherCondition;

@end
