//
//  Triangle3D.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Triangle3DMake(a, b, c) [[Triangle3D alloc] initWithV0:a v1:b v2:c]
#define TSimple3DMake(a, b, c) [[Triangle3D alloc] initWithSimpleV0:a v1:b v2:c]
#define TSimple3DNormalMake(a, b, c, nor) [[Triangle3D alloc] initWithSimpleV0:a v1:b v2:c normal:nor]

@class Vector3D;

@interface Triangle3D : NSObject

@property (nonatomic) int v0Simple;
@property (nonatomic) int v1Simple;
@property (nonatomic) int v2Simple;

@property (strong, nonatomic) Vector3D *v0;
@property (strong, nonatomic) Vector3D *v1;
@property (strong, nonatomic) Vector3D *v2;

@property (nonatomic) CGPoint uvVector0;
@property (nonatomic) CGPoint uvVector1;
@property (nonatomic) CGPoint uvVector2;

@property (strong, nonatomic) Vector3D *normalVector;

@property (strong, nonatomic) Vector3D *v0NormalVector;
@property (strong, nonatomic) Vector3D *v1NormalVector;
@property (strong, nonatomic) Vector3D *v2NormalVector;

- (instancetype)initWithV0:(Vector3D *)v0 v1:(Vector3D *)v1 v2:(Vector3D *)v2;
- (instancetype)initWithSimpleV0:(int)v0 v1:(int)v1 v2:(int)v2;
- (instancetype)initWithSimpleV0:(int) v0 v1:(int) v1 v2:(int) v2 normal:(Vector3D *) normal;

@end
