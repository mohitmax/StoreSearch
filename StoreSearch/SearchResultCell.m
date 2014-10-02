//
//  SearchResultCell.m
//  StoreSearch
//
//  Created by Mohit Sadhu on 7/23/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import "SearchResultCell.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

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

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.artworkImageView cancelImageRequestOperation];
    self.nameLabel.text = nil;
    self.artistNameLabel.text = nil;
}

- (void)configureForSearchResult:(SearchResult *)searchResult
{
    self.nameLabel.text = searchResult.name;
    
    NSString* artistname = searchResult.artistName;
    if(artistname == nil)
    {
        artistname = @"Unknown";
    }
    
    NSString* kind = [searchResult kindForDisplay];
    self.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", artistname, kind];
    
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:searchResult.artworkUrl60] placeholderImage:[UIImage imageNamed:@"Placeholder"]];
    
}




@end
