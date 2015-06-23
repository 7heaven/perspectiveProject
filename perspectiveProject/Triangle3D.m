//
//  Triangle3D.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "Triangle3D.h"

@implementation Triangle3D

- (instancetype)initWithV0:(Vector3D *)v0 v1:(Vector3D *)v1 v2:(Vector3D *)v2 {
    if (self = [super init]) {
        self.v0 = v0;
        self.v1 = v1;
        self.v2 = v2;
    }
    return self;
}

- (instancetype)initWithSimpleV0:(int)v0 v1:(int)v1 v2:(int)v2 {
    if (self = [super init]) {
        self.v0Simple = v0;
        self.v1Simple = v1;
        self.v2Simple = v2;
    }

    return self;
}

- (instancetype)initWithSimpleV0:(int) v0 v1:(int) v1 v2:(int) v2 normal:(Vector3D *) normal{
    if(self = [self initWithSimpleV0:v0 v1:v1 v2:v2]){
        self.normalVector = normal;
    }
    
    return self;
}

@end
