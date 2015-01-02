//
//  BoxObject.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "BoxObject.h"
#import "Vector3D.h"
#import "Triangle3D.h"

@implementation BoxObject

- (instancetype)init {
    self = [super init];

    if (self) {
    }

    return self;
}

- (instancetype)initWithLength:(int)length {
    self = [super init];
    if (self) {
        CGFloat halfLength = length / 2;

        NSLog(@"halfLength:%f", halfLength);

        self.vectorArray = [@[
            Vector3DMake(-halfLength, -halfLength, -halfLength),
            Vector3DMake(halfLength, -halfLength, -halfLength),
            Vector3DMake(halfLength, halfLength, -halfLength),
            Vector3DMake(-halfLength, halfLength, -halfLength),
            Vector3DMake(-halfLength, -halfLength, halfLength),
            Vector3DMake(halfLength, -halfLength, halfLength),
            Vector3DMake(halfLength, halfLength, halfLength),
            Vector3DMake(-halfLength, halfLength, halfLength)
        ] mutableCopy];

        self.triangleArray = [@[
            TSimple3DMake(0, 1, 2),
            TSimple3DMake(0, 2, 3),
            TSimple3DMake(4, 5, 7),
            TSimple3DMake(5, 6, 7),
            TSimple3DMake(4, 0, 3),
            TSimple3DMake(4, 3, 7),
            TSimple3DMake(1, 5, 6),
            TSimple3DMake(1, 6, 2),
            TSimple3DMake(3, 2, 6),
            TSimple3DMake(3, 6, 7),
            TSimple3DMake(4, 0, 1),
            TSimple3DMake(4, 1, 5)
        ] mutableCopy];
    }

    return self;
}

@end
