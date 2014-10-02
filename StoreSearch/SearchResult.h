//
//  SearchResult.h
//  StoreSearch
//
//  Created by Mohit Sadhu on 7/19/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

@import Foundation;

@interface SearchResult : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* artistName;
@property (nonatomic, strong) NSString* artworkUrl60;
@property (nonatomic, strong) NSString* artworkUrl100;
@property (nonatomic, strong) NSString* storeUrl;
@property (nonatomic, strong) NSString* kind;
@property (nonatomic, strong) NSString* currency;
@property (nonatomic, strong) NSString* genre;
@property (nonatomic, strong) NSDecimalNumber* price;

- (NSComparisonResult)compareName:(SearchResult*)other;
- (NSString *)kindForDisplay;

@end
