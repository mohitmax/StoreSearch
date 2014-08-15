//
//  SearchResultCell.m
//  StoreSearch
//
//  Created by Mohit Sadhu on 7/23/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell
 
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [super awakeFromNib];
    
    UIView* selectedView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedView.backgroundColor = [UIColor colorWithRed:20.0/255.0 green:160.0/255.0 blue:160.0/255.0 alpha:0.5];
    self.selectedBackgroundView = selectedView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
