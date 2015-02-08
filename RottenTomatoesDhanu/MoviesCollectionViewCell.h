//
//  MoviesCollectionViewCell.h
//  RottenTomatoesDhanu
//
//  Created by Dhanu Agnihotri on 2/7/15.
//  Copyright (c) 2015 ___SocietyTech___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoviesCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *photoView;
@property (strong, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) IBOutlet UILabel *ratingLabel;
@property (strong, nonatomic) IBOutlet UILabel *runtimeLabel;

@end
