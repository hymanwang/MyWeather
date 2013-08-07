//
//  WeatherContentViewController.m
//  MyWeather
//
//  Created by Hyman Wang on 5/28/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "CityEntity.h"
#import "CityManager.h"
#import "WeatherView.h"
#import "AppDelegate.h"
#import "UIView+frame.h"
#import "ShareViewController.h"
#import "WeatherContentViewController.h"
#import "CityManagementViewController.h"

static const NSInteger beginTag = 100;
@interface WeatherContentViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) WeatherView *currentWeatherView;
@property (strong, nonatomic) CityManager *cityManager;
@property (strong, nonatomic) CityEntity *currentCity;
@property (assign, nonatomic) NSInteger currentCityIndex;

- (IBAction)AddCityButtonClicked:(UIButton *)sender;
- (IBAction)shareButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(UIButton *)sender;

@end

@implementation WeatherContentViewController

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
    self.cityManager = [CityManager sharedCityManeger];
    self.currentCity = [self.cityManager.selectedCityArray objectAtIndex:0];
    [self loadWeatherView];
    self.scrollView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    WPrintBaseLog;
}

- (void)loadWeatherView
{
    for (int i = 0; i < self.cityManager.selectedCityArray.count; i++) {
        CityEntity *cityEntity = [self.cityManager.selectedCityArray objectAtIndex:i];
        self.cityLabel.text = [[self.cityManager.selectedCityArray objectAtIndex:0] cityName];
        WeatherView *view = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:nil options:nil] objectAtIndex:0];
        [view loadViewWithWeatherOfCity:cityEntity refresh:NO];
        [view setOriginX:self.scrollView.width * i];
        [view setTag:beginTag + i];
        [self.scrollView addSubview:view];
    }
    [self.scrollView setContentSize:CGSizeMake(self.cityManager.selectedCityArray.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

#pragma mark - actions

- (IBAction)AddCityButtonClicked:(UIButton *)sender
{
    CityManagementViewController *controller = [[CityManagementViewController alloc] init];
    controller.delegate = self;
    [self presentViewController:controller animated:YES completion:^{
        
    }];
}

- (IBAction)shareButtonClicked:(id)sender
{
//    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
//    SinaWeibo *sinaweibo = appDelegate.sinaWeibo;
//    [sinaweibo logIn];
    ShareViewController *shareViewcontroller = [[ShareViewController alloc] init];
    [shareViewcontroller loadSharedMessageWith:self.currentCity weatherImage:nil];
    [self presentViewController:shareViewcontroller animated:YES completion:^{
        
    }];
}

- (IBAction)refreshButtonClicked:(UIButton *)sender
{
    WeatherView *currentView = (WeatherView *)[self.scrollView viewWithTag:beginTag + _currentCityIndex];
    [currentView loadViewWithWeatherOfCity:[self.cityManager.selectedCityArray objectAtIndex:_currentCityIndex] refresh:YES];
}

#pragma mark - city list changed delegate

- (void)addNewCityToWeatherContentView:(CityEntity *)city
{
    WeatherView *view = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:nil options:nil] objectAtIndex:0];
    [view loadViewWithWeatherOfCity:city refresh:YES];
    NSInteger index = [self.cityManager.selectedCityArray indexOfObject:city];
    [view setOriginX:index * view.width];
    [view setTag:beginTag + index];
    self.cityLabel.text =city.cityName;
    [self.scrollView addSubview:view];
    [self.scrollView setContentSize:CGSizeMake(self.cityManager.selectedCityArray.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

- (void)removeCityFromWeatherContentView:(CityEntity *)city
{
    [self resetCityWeatherContentView];
    [self.scrollView setContentSize:CGSizeMake(self.cityManager.selectedCityArray.count * self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
}

- (void)resetCityWeatherContentView
{
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.cityManager.selectedCityArray.count; i++) {
        CityEntity *city = [self.cityManager.selectedCityArray objectAtIndex:i];
        self.cityLabel.text =city.cityName;
        WeatherView *view = [[[NSBundle mainBundle] loadNibNamed:@"WeatherView" owner:nil options:nil] objectAtIndex:0];
        [view loadViewWithWeatherOfCity:city refresh:NO];
        [view setTag:beginTag + i];
        [view setOriginX:self.scrollView.width * i];
        [self.scrollView addSubview:view];
    }
}

- (void)moveToSelectedCity:(CityEntity *)city
{
    self.currentCity = city;
    [self.scrollView setContentOffset:CGPointMake([self.cityManager indexOfCity:city] * self.scrollView.width, 0.0)];
}

#pragma mark - scroll view delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = floor((scrollView.contentOffset.x - scrollView.width / 2) / scrollView.width) + 1;
    index = index<0?0:index;
    _currentCityIndex = index;
    CityEntity *currentCity = [self.cityManager.selectedCityArray objectAtIndex:_currentCityIndex];
    self.currentCity = currentCity;
    self.cityLabel.text = currentCity.cityName;
}

#pragma mark - SinaWeibo Delegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogIn userID = %@ accesstoken = %@ expirationDate = %@ refresh_token = %@", sinaweibo.userID, sinaweibo.accessToken, sinaweibo.expirationDate,sinaweibo.refreshToken);
    [self saveWeiboAuthData];
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeWeiboAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeWeiboAuthData];
}

- (void)saveWeiboAuthData
{
    SinaWeibo *weibo = ((AppDelegate *)[UIApplication sharedApplication].delegate).sinaWeibo;
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              weibo.accessToken, @"AccessTokenKey",
                              weibo.expirationDate, @"ExpirationDateKey",
                              weibo.userID, @"UserIDKey",
                              weibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeWeiboAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

@end
