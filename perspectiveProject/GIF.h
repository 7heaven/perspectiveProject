//
//  GIF.h
//  perspectiveProject
//
//  Created by 7heaven on 15/1/3.
//  Copyright (c) 2015年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GIF : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *imageSeries;
@property (strong, nonatomic, readonly) NSMutableArray *durations;

@property (nonatomic) BOOL repeat;

- (void)appendImage:(NSImage *)image withNextDuration:(NSInteger)duration;

@end
