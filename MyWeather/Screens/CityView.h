//
//  CityView.h
//  MyWeather
//
//  Created by Hyman Wang on 6/5/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CityManagementViewController.h"

@class CityEntity;
@interface CityView : UIView

@property (assign, nonatomic) id<CityViewDelegate> delegate;
@property (assign, nonatomic) id<CityViewStatusDelegate> statusDelegate;

- (CityEntity *)city;
- (void)loadCityViewWith:(CityEntity *)city fresh:(BOOL)fresh;
- (void)loadCityWeather;
- (void)showDeleteButtonByJiggle:(BOOL)isJiggling;

@end
