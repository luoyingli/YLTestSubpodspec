//
//  UIView+Extension.m
//  TestSubspec
//
//  Created by luoyingli on 2019/2/14.
//  Copyright © 2019 luoyingli. All rights reserved.
//

#import "UIView+Extension.h"


typedef NS_ENUM(NSInteger, YLLineDirection)
{
    YLLineDirectionUp = 0,
    YLLineDirectionDown,
    YLLineDirectionLeft,
    YLLineDirectionRight
};

@implementation UIView (Extension)

+ (NSString *)cacheKeyWithColor:(UIColor *)color direction:(YLLineDirection)direction
{
    CGFloat r,g,b;
    [color getRed:&r green:&g blue:&b alpha:NULL];
    return [NSString stringWithFormat:@"%f_%f_%f_%@", r, g, b, @(direction)];
}

@end
