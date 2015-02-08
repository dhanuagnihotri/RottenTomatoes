//
//  DVDViewController.m
//  RottenTomatoesDhanu
//
//  Created by Dhanu Agnihotri on 2/5/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "DVDViewController.h"
#import "MoviesTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "MovieDetailViewController.h"
#import "SVProgressHUD.h"

@interface DVDViewController () <UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableView *dvdTableView;
@property (strong, nonatomic) NSArray *movies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation DVDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dvdTableView.dataSource = self;
    self.dvdTableView.delegate = self;
    
    [self.dvdTableView registerNib:[UINib nibWithNibName:@"MoviesTableViewCell" bundle:nil] forCellReuseIdentifier:@"MovieCell"];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(onRefresh) forControlEvents:UIControlEventValueChanged];
    [self.dvdTableView insertSubview:self.refreshControl atIndex:0];
    
    
    self.dvdTableView.rowHeight = 100;
    
    self.title = @"DVDs";
    
    [self onRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Movie Tableview methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MoviesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
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
    vc.movie = self.movies[indexPath.row];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIRefresh

- (void)onRefresh {
    
    NSURL *url = [NSURL URLWithString:@"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=bngz4p8ef9hpew9ssk4c8f4w"];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    [SVProgressHUD show];
    [ NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        [SVProgressHUD dismiss];
        [self.refreshControl endRefreshing];
        
        self.movies = responseDict[@"movies"];
        
        [self.dvdTableView reloadData];
    }];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
