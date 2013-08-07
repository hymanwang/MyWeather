//
//  ShareViewController.m
//  MyWeather
//
//  Created by Hyman Wang on 6/19/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "ShareViewController.h"
#import "CityEntity.h"

@interface ShareViewController ()

@property (strong, nonatomic) CityEntity *city;

@property (weak, nonatomic) IBOutlet UILabel *sharedMessageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImageView;
@property (weak, nonatomic) IBOutlet UIImageView *faceBookImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sinaWeiboImageView;
@property (weak, nonatomic) IBOutlet UIImageView *tencentImageView;

@end

@implementation ShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sharedMessageLabel.text = self.city.temp;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSharedMessageWith:(CityEntity *)city weatherImage:(UIImage *)weatherImage
{
    self.city = city;
}


- (IBAction)backButtonClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)shareButtonClicked:(id)sender
{
    
}

- (IBAction)smsButtonClicked:(id)sender
{
    
}

@end
