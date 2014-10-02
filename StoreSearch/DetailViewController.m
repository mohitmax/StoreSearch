//
//  DetailViewController.m
//  StoreSearch
//
//  Created by Mohit Sadhu on 10/2/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import "DetailViewController.h"
#import "SearchResult.h"
#import <AFNetworking/UIImageView+AFNetworking.h>

@interface DetailViewController ()

@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.popupView.layer.cornerRadius = 10.f;
    self.view.backgroundColor = [UIColor clearColor];
    
    UIImage* image = [[UIImage imageNamed:@"PriceButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.priceButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.view.tintColor = [UIColor colorWithRed:20/255.f green:160/255.f blue:160/255.f alpha:1.f];
    
    UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close:)];
    tapGesture.cancelsTouchesInView = NO;
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    if (self.searchResult != nil)
    {
        [self update];
    }
}

- (void)update
{
    self.nameLabel.text = self.searchResult.name;
    
    NSString* artistName = self.searchResult.artistName;
    if (artistName == nil)
    {
        artistName = @"Unknkown";
    }
    
    self.artistNameLabel.text = artistName;
    self.kindLabel.text = [self.searchResult kindForDisplay];
    self.genreLabel.text = self.searchResult.genre;
    [self.artworkImageView setImageWithURL:[NSURL URLWithString:self.searchResult.artworkUrl100]];
    
    NSNumberFormatter* formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [formatter setCurrencyCode:self.searchResult.currency];
    
    NSString* priceText;
    if ([self.searchResult.price floatValue] == 0.0f)
    {
        priceText = @"Free";
    }
    else
    {
        priceText = [formatter stringFromNumber:self.searchResult.price];
    }
    [self.priceButton setTitle:priceText forState:UIControlStateNormal];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIGestureRecognizer Delegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return (touch.view == self.view);
}

#pragma mark - Action methods
- (IBAction)close:(id)sender
{
    [self willMoveToParentViewController:nil];
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)openInStore:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.searchResult.storeUrl]];
}

- (void) dealloc
{
    NSLog(@"dealloc %@", self);
    [self.artworkImageView cancelImageRequestOperation];
}


@end
