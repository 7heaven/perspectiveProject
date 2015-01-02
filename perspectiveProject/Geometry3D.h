//
//  Geometry3D.h
//  perspectiveProject
//
//  Created by 7heaven on 15/1/2.
//  Copyright (c) 2015年 7heaven. All rights reserved.
//

#ifndef perspectiveProject_Geometry3D_h
#define perspectiveProject_Geometry3D_h

struct {
    CGFloat x, CGFloat y, CGFloat z, CGFloat w
} Vector3D;

struct {
    Vector3D a, Vector3D b, Vector3D c
} Triangle3D;

static inline Triangle3D Triangle3DMake(Vector3D a, Vector3D b, Vector3D c) {
    Triangle3D t;
    t.a = a;
    t.b = b;
    t.c = c;
    return t;
}

static inline Vector3D Vector3DMake(CGFloat x, CGFloat y, CGFloat z) {
    Vector3D v;
    v.x = x;
    v.y = y;
    v.z = z;
    v.w = 1;
    return v;
}

#endif
