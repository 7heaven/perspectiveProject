//
//  ColorUtil.h
//  perspectiveProject
//
//  Created by 7heaven on 15/1/1.
//  Copyright (c) 2015年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define color(c) [ColorUtil colorFromHexString:c]

@interface ColorUtil : NSObject
+ (NSColor *)colorFromHexString:(NSString *)hexString;

@end
