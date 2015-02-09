//
//  MovieDetailViewController.m
//  RottenTomatoesDhanu
//
//  Created by Dhanu Agnihotri on 2/5/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import "MovieDetailViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *posterView;

@end

@implementation MovieDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *url = [self.movie valueForKeyPath:@"posters.original"];
    [self.posterView setImageWithURL:[NSURL URLWithString:url]];
    url = [url stringByReplacingOccurrencesOfString:@"_tmb"
                                         withString:@"_ori"];
    
    __weak typeof(self) weakSelf = self;
    [self.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]
                          placeholderImage:nil
                                   success:^(NSURLRequest *request , NSHTTPURLResponse *response , UIImage *image ){
                                       weakSelf.posterView.image=image;
                                   }
                                   failure:nil
     ];
    
    NSMutableString *titleString = [NSMutableString stringWithString:self.movie[@"title"]];
    self.navigationItem.title = titleString;

    NSNumber *year = self.movie[@"year"];
    [titleString appendString:[NSString stringWithFormat:@" (%@)", year.stringValue]];
    self.titleLabel.text = titleString;
    [self.titleLabel sizeToFit];

    NSMutableString *scoreString = [NSMutableString stringWithString:@"Critics score:"];
    NSNumber *score = [self.movie valueForKeyPath:@"ratings.critics_score"];
    [scoreString appendString:[NSString stringWithFormat:@"%@, Audience score:", score.stringValue]];
    score = [self.movie valueForKeyPath:@"ratings.audience_score"];
    [scoreString appendString:[NSString stringWithFormat:@"%@", score.stringValue]];
    self.score.text = scoreString;

    self.mpaa_rating.text = self.movie[@"mpaa_rating"];
    self.mpaa_rating.layer.borderColor = [UIColor grayColor].CGColor;
    self.mpaa_rating.layer.borderWidth = 1.0;
    
    self.synopsis.text = self.movie[@"synopsis"];
    [self.synopsis sizeToFit];
    
    CGSize size = self.synopsis.frame.size;
    
    CGRect frame = [self.movieTextView frame];
    frame.size.height += size.height;
    [self.movieTextView setFrame:frame];
    
    [self.scroller setScrollEnabled:YES];
    self.scroller.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+size.height-100);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
