//
//  SearchResultCell.h
//  StoreSearch
//
//  Created by Mohit Sadhu on 7/23/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@end
