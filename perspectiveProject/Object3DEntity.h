//
//  Object3DEntity.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Object3DEntity : NSObject

@property (strong, nonatomic) NSMutableArray *vectorArray;
@property (strong, nonatomic) NSMutableArray *triangleArray;
@property (strong, nonatomic) NSMutableArray *uvMapArray;

@end
