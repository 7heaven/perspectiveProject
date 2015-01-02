//
//  ColorUtil.m
//  perspectiveProject
//
//  Created by 7heaven on 15/1/1.
//  Copyright (c) 2015年 7heaven. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "ColorUtil.h"

@implementation ColorUtil

+ (NSColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];

    BOOL alphaInvoked = NO;

    if ([hexString hasPrefix:@"#"]) {
        [scanner setScanLocation:1];
        if ([hexString length] >= 9) {
            alphaInvoked = YES;
        }
    }
    if ([hexString hasPrefix:@"0x"]) {
        [scanner setScanLocation:2];
        if ([hexString length] >= 10) {
            alphaInvoked = YES;
        }
    }

    [scanner scanHexInt:&rgbValue];

    CGFloat alphaValue = ((rgbValue & 0xFF000000) >> 24) / 255.0F;

    return [NSColor colorWithCalibratedRed:((rgbValue & 0xFF0000) >> 16) / 255.0F
                                     green:((rgbValue & 0x00FF00) >> 8) / 255.0F
                                      blue:(rgbValue & 0x0000FF) / 255.0F
                                     alpha:alphaInvoked ? alphaValue : 1.0F];
}

@end
