//
//  ShareViewController.h
//  MyWeather
//
//  Created by Hyman Wang on 6/19/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CityEntity;
@interface ShareViewController : UIViewController

- (void)loadSharedMessageWith:(CityEntity *)city weatherImage:(UIImage *)weatherImage;

@end
