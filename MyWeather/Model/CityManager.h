//
//  CityManager.h
//  MyWeather
//
//  Created by Hyman Wang on 6/5/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CityEntity;
@interface CityManager : NSObject

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentScoreCoordinator;

+ (CityManager *)sharedCityManeger;

- (NSMutableArray *)selectedCityArray;
- (BOOL)addNewCity:(CityEntity *)aCity;
- (NSMutableArray *)queryCityWithCityName:(NSString *)cityName;
- (NSMutableArray *)queryCityWithCityCode:(NSString *)cityCode;
- (BOOL)updateWithCity:(CityEntity *)aCity;
- (BOOL)removeCity:(CityEntity *)aCity;
- (BOOL)cityHasSelected:(NSString *)cityName;
- (NSInteger)indexOfCity:(CityEntity *)city;
- (NSMutableArray *)getAllCities;

@end
