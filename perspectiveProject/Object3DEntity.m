//
//  Object3DEntity.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "Object3DEntity.h"

@implementation Object3DEntity

- (instancetype)init {
    if (self = [super init]) {
        self.vectorArray = [[NSMutableArray alloc] init];
        self.triangleArray = [[NSMutableArray alloc] init];
        self.uvMapArray = [[NSMutableArray alloc] init];
    }

    return self;
}

@end
