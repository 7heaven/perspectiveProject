//
//  GIF.m
//  perspectiveProject
//
//  Created by 7heaven on 15/1/3.
//  Copyright (c) 2015年 7heaven. All rights reserved.
//

#import "GIF.h"

@implementation GIF

- (instancetype)init {
    if (self = [super init]) {
        _imageSeries = [[NSMutableArray alloc] init];
        _durations = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)appendImage:(NSImage *)image withNextDuration:(NSInteger)duration {
    [_imageSeries addObject:image];
    [_durations addObject:@(duration)];
}

@end
