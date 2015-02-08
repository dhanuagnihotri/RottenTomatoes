//
//  MovieDetailViewController.h
//  RottenTomatoesDhanu
//
//  Created by Dhanu Agnihotri on 2/5/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieDetailViewController : UIViewController

@property (strong,nonatomic) NSDictionary *movie;
@property (strong, nonatomic) IBOutlet UIView *movieTextView;
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *mpaa_rating;

@property (strong, nonatomic) IBOutlet UILabel *synopsis;

@end
