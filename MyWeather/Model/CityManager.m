//
//  CityManager.m
//  MyWeather
//
//  Created by Hyman Wang on 6/5/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "CityManager.h"
#import "City.h"
#import "CityEntity.h"

@interface CityManager()

@property (strong, nonatomic) NSMutableArray *selectedCityArray;
@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentScoreCoordinator;

@end

@implementation CityManager

+ (CityManager *)sharedCityManeger
{
    static id instance = nil;
    if (instance == nil) {
        instance = [[CityManager alloc] init];
    }
    return instance;
}

- (NSMutableArray *)selectedCityArray
{
    return _selectedCityArray;
}

- (id)init
{
    self = [super init];
    if (self) {
        self.selectedCityArray = [NSMutableArray array];
        [self managedObjectModel];
        [self persistentScoreCoordinator];
        [self managedObjectContext];
        self.selectedCityArray = [self getAllCities];
    }
    return  self;
}

- (BOOL)cityHasSelected:(NSString *)cityName
{
    for (CityEntity *city in self.selectedCityArray) {
        if ([city.cityName isEqualToString:cityName]) {
            return YES;
        }
    }
    return NO;
}

- (NSInteger)indexOfCity:(CityEntity *)city
{
    NSInteger index = [self.selectedCityArray indexOfObject:city];
    if (index != NSNotFound) {
        return index;
    }
    return 0;
}

#pragma mark - core data model
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CityAndWeather" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentScoreCoordinator
{
    if (_persistentScoreCoordinator != nil) {
        return _persistentScoreCoordinator;
    }
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSURL *storeURL = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"CityAndWeather.data"]];
    _persistentScoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                   initWithManagedObjectModel:_managedObjectModel];
    NSError *error = nil;
    if (![_persistentScoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:storeURL
                                                         options:nil
                                                           error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    };
    return _persistentScoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentScoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (BOOL)saveManagedObjectContext
{
    NSError *error;
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Error saving: %@", [error description]);
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - crud methods
- (BOOL)addNewCity:(CityEntity *)aCity
{
    [self.selectedCityArray addObject:aCity];
//    CityEntity *cityEntity =aCity;
//    cityEntity.cityCode = aCity.cityCode;
//    cityEntity.cityName = aCity.cityName;
    return [self saveManagedObjectContext];
}

- (NSMutableArray *)queryCityWithCityName:(NSString *)cityName
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityEntity"
                                              inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityName = %@", cityName];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Error fetching result %@", [error description]);
    }
    return mutableFetchResults;
}

- (NSMutableArray *)queryCityWithCityCode:(NSString *)cityCode
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityEntity"
                                              inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"cityCode = %@", cityCode];
    [request setPredicate:predicate];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Error fetching result %@", [error description]);
    }
    return mutableFetchResults;
}

- (NSMutableArray *)getAllCities
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CityEntity"
                                              inManagedObjectContext:_managedObjectContext];
    [request setEntity:entity];
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[_managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (mutableFetchResults == nil) {
        NSLog(@"Error fetching result %@", [error description]);
    }
    return mutableFetchResults;
}

- (BOOL)removeCity:(CityEntity *)aCity
{
    [self.selectedCityArray removeObject:aCity];
    NSMutableArray *results = [self queryCityWithCityName:aCity.cityName];
    if ([results count] == 0) {
        return NO;
    } else {
        CityEntity *cityEntity = [results objectAtIndex:0];
        [_managedObjectContext deleteObject:cityEntity];
        return [self saveManagedObjectContext];
    }
}

- (BOOL)updateWithCity:(CityEntity *)aCity
{
    NSMutableArray *results = [self queryCityWithCityName:aCity.cityName];
    CityEntity *cityEntity = [results objectAtIndex:0];
    cityEntity.cityCode = aCity.cityCode;
    cityEntity.cityName = aCity.cityName;
    return [self saveManagedObjectContext];
}


@end
