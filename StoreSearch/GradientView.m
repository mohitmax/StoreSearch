//
//  GradientView.m
//  StoreSearch
//
//  Created by Mohit Sadhu on 10/2/14.
//  Copyright (c) 2014 ms. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

/*
 Only override drawRect: if you perform custom drawing.
 An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    //1
    const CGFloat components[8] = { 0.0f, 0.0f, 0.0f, 0.2f,
                                    0.0f, 0.0f, 0.0f, 0.7f };
    const CGFloat locations[2] = { 0.0f, 1.0f };
    
    //2
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(space, components, locations, 2);
    CGColorSpaceRelease(space);
    
    //3
    CGFloat x = CGRectGetMidX(self.bounds);
    CGFloat y = CGRectGetMidY(self.bounds);
    CGPoint point = CGPointMake(x, y);
    CGFloat radius = MAX(x, y);
    
    //4
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawRadialGradient(context, gradient, point, 0, point, radius, kCGGradientDrawsAfterEndLocation);
    
    //5
    CGGradientRelease(gradient);
}


@end
