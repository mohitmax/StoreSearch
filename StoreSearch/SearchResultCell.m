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

- (void)configureForSearchResult:(SearchResult *)searchResult
{
    self.nameLabel.text = searchResult.name;
    
    NSString* artistname = searchResult.artistName;
    if(artistname == nil)
    {
        artistname = @"Unknown";
    }
    
    NSString* kind = [self kindForDisplay:searchResult.kind];
    self.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", artistname, kind];
}

- (NSString *)kindForDisplay:(NSString *)kind
{
    if ([kind isEqualToString:@"album"])
    {
        return @"Album";
    }
    else if ([kind isEqualToString:@"audiobook"])
    {
        return @"Audio Book";
    }
    else if ([kind isEqualToString:@"book"])
    {
        return @"Book";
    }
    else if ([kind isEqualToString:@"ebook"])
    {
        return @"E-Book";
    }
    else if ([kind isEqualToString:@"feature-movie"])
    {
        return @"Movie";
    }
    else if ([kind isEqualToString:@"music-video"])
    {
        return @"Music Video";
    }
    else if ([kind isEqualToString:@"podcast"])
    {
        return @"Podcast";
    }
    else if ([kind isEqualToString:@"software"])
    {
        return @"App";
    }
    else if ([kind isEqualToString:@"song"])
    {
        return @"Song";
    }
    else if ([kind isEqualToString:@"tv-episode"])
    {
        return @"TV Episode";
    }
    else
    {
        return kind;
    }
}


@end
