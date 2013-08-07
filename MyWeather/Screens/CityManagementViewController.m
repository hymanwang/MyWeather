//
//  CityManagementViewController.m
//  MyWeather
//
//  Created by Hyman Wang on 6/5/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "CityEntity.h"
#import "CityView.h"
#import "CityManager.h"
#import "UIView+Jiggle.h"
#import "CityListViewController.h"
#import "CityManagementViewController.h"

static const NSInteger countInRow = 3;

struct Cindex
{
    NSInteger rowindex;
    NSInteger columnIndex;
};

static const struct Cindex indexZero = {0, 0};

@interface CityManagementViewController ()

@property (assign, nonatomic) CGRect lastViewFrame;
@property (strong, nonatomic) CityManager *cityManager;
@property (assign, nonatomic) struct Cindex lastViewIndex;
@property (assign, nonatomic) BOOL isJiggling;
@property (strong, nonatomic) UITapGestureRecognizer *tap;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)addButtonClicked:(id)sender;
- (IBAction)refreshButtonClicked:(id)sender;

@end

@implementation CityManagementViewController

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
    
    NSArray *cityArray = [self.cityManager selectedCityArray];
    _lastViewFrame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    _lastViewIndex = indexZero;
    for (CityEntity *city in cityArray) {
        CityView *cityView = [[[NSBundle mainBundle] loadNibNamed:@"CityView" owner:nil options:nil] objectAtIndex:0];
        [cityView setFrame:[self getFrameWithIndex:_lastViewIndex lastFrame:_lastViewFrame]];
        [cityView loadCityViewWith:city fresh:NO];
//        [cityView loadCityWeather];
        cityView.delegate = self;
        cityView.statusDelegate = self;
        [self.scrollView addSubview:cityView];
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, _lastViewFrame.origin.y + _lastViewFrame.size.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.delegate = nil;
    WPrintBaseLog;
}

- (CGRect)getFrameWithIndex:(struct Cindex)index lastFrame:(CGRect)lastFrame
{
    CGRect viewFrame = CGRectMake(lastFrame.size.width * (index.rowindex % countInRow),
                                  lastFrame.size.height * index.columnIndex,
                                  lastFrame.size.width,
                                  lastFrame.size.height);
    if ((++index.rowindex % countInRow) == 0) {
        index.columnIndex++;
    }
    viewFrame.origin.x += 10.0;
    _lastViewFrame = viewFrame;
    _lastViewIndex = index;
    return viewFrame;
}

- (void)addNewCityWithCityName:(NSString *)cityName cityCode:(NSString *)cityCode
{
    CityView *cityView = [[[NSBundle mainBundle] loadNibNamed:@"CityView" owner:nil options:nil] objectAtIndex:0];
    CityEntity *cityEntity = (CityEntity *)[NSEntityDescription insertNewObjectForEntityForName:@"CityEntity" inManagedObjectContext:self.cityManager.managedObjectContext];
    cityEntity.cityCode = cityCode;
    cityEntity.cityName = cityName;
    [cityView setFrame:[self getFrameWithIndex:_lastViewIndex lastFrame:_lastViewFrame]];
    [cityView loadCityViewWith:cityEntity fresh:YES];
    [cityView loadCityWeather];
    [self.cityManager addNewCity:cityEntity];
    
    cityView.delegate = self;
    cityView.statusDelegate = self;
    [self.scrollView addSubview:cityView];
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, _lastViewFrame.origin.y + _lastViewFrame.size.height)];
    
    if ([self.delegate respondsToSelector:@selector(addNewCityToWeatherContentView:)]) {
        [self.delegate addNewCityToWeatherContentView:cityEntity];
    }
}

- (void)removeCity:(CityEntity *)city
{
    [self.cityManager removeCity:city];
    if ([self.delegate respondsToSelector:@selector(removeCityFromWeatherContentView:)]) {
        [self.delegate removeCityFromWeatherContentView:city];
    }
}

- (void)resetFrameForAllViews
{
    _lastViewFrame = CGRectMake(0.0f, 0.0f, 100.0f, 100.0f);
    _lastViewIndex = indexZero;
    for (CityView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[CityView class]]) {
            [UIView animateWithDuration:0.3 animations:^{
                [view setFrame:[self getFrameWithIndex:_lastViewIndex lastFrame:_lastViewFrame]];
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, _lastViewFrame.origin.y + _lastViewFrame.size.height)];
}

#pragma mark - actions
- (IBAction)backButtonClicked:(id)sender
{
    [self stopJigglingForAllViews];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)addButtonClicked:(id)sender
{
    [self stopJigglingForAllViews];
    CityListViewController *cityListViewController = [[CityListViewController alloc] init];
    [self presentViewController:cityListViewController animated:YES completion:^{
        
    }];
}

- (IBAction)refreshButtonClicked:(id)sender
{
    [self stopJigglingForAllViews];
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[CityView class]]) {
            [((CityView *)view) loadCityWeather];
        }
    }
}

#pragma mark - city view delegate
- (void)backToWeatherContentViewWithCity:(CityEntity *)city
{
    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(moveToSelectedCity:)]) {
            [self.delegate moveToSelectedCity:city];
        }
    }];
}

#pragma mark - city view status delegate
- (void)startJiggleForAllView
{
    _isJiggling = YES;
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[CityView class]]) {
            [((CityView *)view) startJiggling];
            [((CityView *)view) showDeleteButtonByJiggle:_isJiggling];
        }
    }
    if (!self.tap) {
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stopJigglingForAllViews)];
    }
    [self.scrollView addGestureRecognizer:self.tap];
}

- (void)deleteView:(CityView *)cityView
{
    [cityView removeFromSuperview];
    [self removeCity:cityView.city];
    [self resetFrameForAllViews];
}

- (void)stopJigglingForAllViews
{
    if (!_isJiggling) {
        return;
    }
    _isJiggling = NO;
    for (UIView *view in self.scrollView.subviews) {
        if ([view isKindOfClass:[CityView class]]) {
            [((CityView *)view) stopJiggling];
            [((CityView *)view) showDeleteButtonByJiggle:_isJiggling];
        }
    }
    [self.scrollView removeGestureRecognizer:self.tap];
}
@end
