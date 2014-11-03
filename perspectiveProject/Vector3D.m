//
//  Vector3D.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "Vector3D.h"

@implementation Vector3D

- (instancetype) initWithX:(CGFloat) x
                         y:(CGFloat) y
                         z:(CGFloat) z{
    self = [super init];
    if(self){
        self.x = x;
        self.y = y;
        self.z = z;
    }
    
    return self;
}

- (Vector3D *) normalizeVector{
    
    int distance = sqrt(self.x * self.x + self.y * self.y + self.z * self.z);
    
    self.x /= distance;
    self.y /= distance;
    self.z /= distance;
    
    return self;
}

@end
