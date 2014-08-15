//
//  SearchResult.m
//  StoreSearch
//
//  Created by Mohit Sadhu on 7/19/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import "SearchResult.h"

@implementation SearchResult
 
- (NSComparisonResult)compareName: (SearchResult*)other
{
    return [self.name localizedStandardCompare:other.name];
}

@end
