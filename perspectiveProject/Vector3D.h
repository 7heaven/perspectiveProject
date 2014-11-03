//
//  Vector3D.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Vector3D : NSObject

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGFloat z;
@property (nonatomic) CGFloat w;

@property (nonatomic) CGFloat x2d;
@property (nonatomic) CGFloat y2d;

- (instancetype) initWithX:(CGFloat) x
                         y:(CGFloat) y
                         z:(CGFloat) z;

- (Vector3D *) normalizeVector;

@end
