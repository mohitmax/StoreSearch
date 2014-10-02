//
//  DetailViewController.h
//  StoreSearch
//
//  Created by Mohit Sadhu on 10/2/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIView* popupView;
@property (nonatomic, strong) IBOutlet UIImageView* artworkImageView;
@property (nonatomic, strong) IBOutlet UILabel* nameLabel;
@property (nonatomic, strong) IBOutlet UILabel* artistNameLabel;
@property (nonatomic, strong) IBOutlet UILabel* kindLabel;
@property (nonatomic, strong) IBOutlet UILabel* genreLabel;
@property (nonatomic, strong) IBOutlet UIButton* priceButton;

- (IBAction)close:(id)sender;

@end
