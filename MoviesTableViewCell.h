//
//  MoviesTableViewCell.h
//  RottenTomatoesDhanu
//
//  Created by Dhanu Agnihotri on 2/4/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) IBOutlet UIImageView *photoView;

@end
