//
//  CityListViewController.m
//  MyWeather
//
//  Created by Hyman Wang on 5/29/13.
//  Copyright (c) 2013 Hyman Wang. All rights reserved.
//

#import "CityManager.h"
#import "CityListViewController.h"
#import "CityManagementViewController.h"

@interface CityListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) NSMutableArray *searchedCities;
@property (strong, nonatomic) NSMutableArray *cityArray;
@property (strong, nonatomic) CityManager *cityManager;

@end

@implementation CityListViewController

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
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"cityList" ofType:@"plist"];
    if (path) {
        NSDictionary *cityListDic = [[NSDictionary alloc] initWithContentsOfFile:path];
        self.cityArray = [NSMutableArray array];
        for (NSString *cityName in [cityListDic allKeys]) {
            NSDictionary *cityDic = [[NSDictionary alloc] initWithObjectsAndKeys:[cityListDic objectForKey:cityName], cityName, nil];
            [self.cityArray addObject:cityDic];
        }
    }
    [self resetSearch];
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

- (void)resetSearch
{
    [self.searchedCities removeAllObjects];
    self.searchedCities = [NSMutableArray arrayWithArray:self.cityArray];
    [self.tableView reloadData];
}

- (void)handleSearchForItem:(NSString *)searchItem
{
    NSMutableArray *citiestoRemove = [[NSMutableArray alloc] init];
    
    for (NSDictionary *cityDic in self.cityArray) {
        if ([[[cityDic allKeys] objectAtIndex:0] rangeOfString:searchItem options:NSCaseInsensitiveSearch].location == NSNotFound) {
            [citiestoRemove addObject:cityDic];
        }
    }
    [self.searchedCities removeObjectsInArray:citiestoRemove];
    [self.tableView reloadData];
}

#pragma mark -- table view datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchedCities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CityCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSDictionary *currentCityDic = [self.searchedCities objectAtIndex:indexPath.row];
    cell.textLabel.text = [[currentCityDic allKeys] objectAtIndex:0];
    return cell;
}

#pragma mark -- table view delegate 

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *selectedCity = [self.searchedCities objectAtIndex:indexPath.row];
    CityManagementViewController *lastcontroller = (CityManagementViewController *)self.presentingViewController;
    [self dismissViewControllerAnimated:YES completion:^{
        if (![self.cityManager cityHasSelected:[[selectedCity allKeys] objectAtIndex:0]]) {
            [lastcontroller addNewCityWithCityName:[[selectedCity allKeys] objectAtIndex:0]
                                          cityCode:[[selectedCity allValues] objectAtIndex:0]];
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.searchBar resignFirstResponder];
}

#pragma mark -- search bar delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText length] == 0) {
        [self resetSearch];
        [self.tableView reloadData];
        return;
    }
    [self handleSearchForItem:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self handleSearchForItem:[searchBar text]];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [self.tableView reloadData];
    [self resetSearch];
    [searchBar resignFirstResponder];
}

@end
