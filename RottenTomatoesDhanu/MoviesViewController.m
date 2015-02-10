//
//  MoviesViewController.m
//  RottenTomatoesDhanu
//
//  Created by Dhanu Agnihotri on 2/4/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "MoviesViewController.h"
#import "MoviesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "MoviesCollectionViewCell.h"
#import "SVProgressHUD.h"

@interface MoviesViewController () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDataSource, UICollectionViewDelegate,UISearchBarDelegate >
@property (strong, nonatomic) IBOutlet UITableView *moviesTableView;
@property (strong, nonatomic) IBOutlet UICollectionView *moviesCollectionView;

@property (strong, nonatomic) NSString *query;
@property (strong, nonatomic) NSArray *movies;
@property (strong, nonatomic) NSArray *filteredMovies;

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIView *networkError;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segmentControlValueChanged:(id)sender;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.moviesTableView.dataSource = self;
    self.moviesTableView.delegate = self;
    self.moviesCollectionView.dataSource = self;
    self.moviesCollectionView.delegate = self;
    
    self.searchBar.barStyle = UIBarStyleBlackTranslucent;
    
    self.searchBar.delegate = self;
    
    [self.moviesTableView registerNib:[UINib nibWithNibName:@"MoviesTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    [self.moviesCollectionView registerNib:[UINib nibWithNibName:@"MoviesCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"MovieCollectionCell"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(140, 180)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
    [self.moviesCollectionView setCollectionViewLayout:flowLayout];
  
    self.moviesTableView.rowHeight = 100;
    // This will remove extra separators from tableview
    self.moviesTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.moviesCollectionView.hidden = YES;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.moviesTableView insertSubview:self.refreshControl atIndex:0];

    NSUInteger selectedIndex = self.parentViewController.tabBarController.selectedIndex;
    switch (selectedIndex) {
        case 0:
            self.query = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=bngz4p8ef9hpew9ssk4c8f4w";
            break;
        case 1:
            self.query = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=bngz4p8ef9hpew9ssk4c8f4w";
            break;
            
        default:
            break;
    }
    
    [self onRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

#pragma mark - Movie Tableview methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filteredMovies.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];

    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.photoView setImageWithURL:[NSURL URLWithString:url]];
    [cell.photoView.layer setBorderColor: [[UIColor whiteColor] CGColor]];
    [cell.photoView.layer setBorderWidth: 1.0];
        
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieDetailViewController *vc = [[MovieDetailViewController alloc]init];
    vc.movie = self.filteredMovies[indexPath.row];
    
    vc.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:vc animated:YES];
}

-(void) tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.contentView.backgroundColor = [UIColor orangeColor];
    cell.backgroundColor = [UIColor orangeColor];
    
}

#pragma mark - Movie Collectionview methods 
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
     return self.filteredMovies.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
   
    MoviesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"MovieCollectionCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    
    cell.infoLabel.text = movie[@"title"];
    cell.ratingLabel.text = movie[@"mpaa_rating"];

    NSNumber *time = movie[@"runtime"];
    NSString *timeString = [NSString stringWithFormat:@"%@ minutes",time.stringValue];
    cell.runtimeLabel.text = timeString;
    
    NSString *url = [movie valueForKeyPath:@"posters.thumbnail"];
    [cell.photoView setImageWithURL:[NSURL URLWithString:url]];

    cell.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.layer.borderWidth = 1.0f;
    cell.layer.cornerRadius = 3.0f;
    
    return cell;
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
 
    MovieDetailViewController *vc = [[MovieDetailViewController alloc]init];
    vc.movie = self.filteredMovies[indexPath.row];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark - UIRefresh 

- (void)onRefresh {
   
    NSURL *url = [NSURL URLWithString:self.query];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [SVProgressHUD show];
    [ NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        //For now just checking for basic networking errors
        if(connectionError!=nil || connectionError.code ==  NSURLErrorNotConnectedToInternet || connectionError.code
           == NSURLErrorNetworkConnectionLost)
        {
            [self showNetworkError];
        }
        else
        {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            self.movies = responseDict[@"movies"];
            self.filteredMovies = self.movies;
            
            [self.networkError removeFromSuperview];
            [self.moviesTableView reloadData];
            [self.moviesCollectionView reloadData];
           
        }

        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        
     }];
    
}

-(void)showNetworkError
{
    self.networkError = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    self.networkError.backgroundColor = [UIColor grayColor];
    
    UILabel *label =[[UILabel alloc] initWithFrame:CGRectMake(125, 32, 200, 100)];
    label.text = @"Network Error";
    label.textColor = [UIColor whiteColor];
    [label setFont:[UIFont systemFontOfSize:12]];
    [self.networkError addSubview:label];
    
    UIImageView *errorImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 72, 18, 18)];
    errorImage.image = [UIImage imageNamed:@"Error_Triangle"];
    [self.networkError addSubview:errorImage];
    
    [self.view addSubview:self.networkError];
}

#pragma mark - Searchbar delegate 

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if(searchText.length == 0)
    {
        self.filteredMovies = self.movies;
        [self performSelector:@selector(searchBarCancelButtonClicked:) withObject:self.searchBar afterDelay: 0.1];
    }
    else
    {
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF.title contains[cd] %@", searchText];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:resultPredicate];
    }
    [self.moviesTableView reloadData];
    [self.moviesCollectionView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) aSearchBar {
    [aSearchBar resignFirstResponder];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Segment control

- (IBAction)segmentControlValueChanged:(id)sender {

    if(self.segmentControl.selectedSegmentIndex == 0)
    {
        [self.moviesTableView insertSubview:self.refreshControl atIndex:0];
        self.moviesTableView.hidden = NO;
        self.moviesCollectionView.hidden = YES;
    }
    else
    {
        self.moviesTableView.hidden = YES;
        [self.moviesCollectionView insertSubview:self.refreshControl atIndex:0];
        self.moviesCollectionView.hidden = NO;
    }
}
@end
