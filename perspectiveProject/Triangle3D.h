//
//  Triangle3D.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Vector3D;

@interface Triangle3D : NSObject

@property (strong, nonatomic) Vector3D *v0;
@property (strong, nonatomic) Vector3D *v1;
@property (strong, nonatomic) Vector3D *v2;

@property (nonatomic) NSPoint uvVector0;
@property (nonatomic) NSPoint uvVector1;
@property (nonatomic) NSPoint uvVector2;

@property (strong, nonatomic) Vector3D *normalVector;

@property (strong, nonatomic) Vector3D *v0NormalVector;
@property (strong, nonatomic) Vector3D *v1NormalVector;
@property (strong, nonatomic) Vector3D *v2NormalVector;

@end
