//
//  StageView.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/29.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "StageView.h"
#import "ColorUtil.h"
#import "Vector3D.h"
#import "BoxObject.h"
#import "Triangle3D.h"

#define setPixel(a, b, c, d) [self setPixelX:a y:b context:c color:d];

#define line(a, b, ctx, color)                                                                         \
    {                                                                                                  \
        CGContextBeginPath(ctx);                                                                       \
        CGContextSetRGBStrokeColor(ctx, color.redComponent, color.greenComponent, color.blueComponent, \
                                   color.alphaComponent);                                              \
        CGContextMoveToPoint(ctx, a.x, a.y);                                                           \
        CGContextAddLineToPoint(ctx, b.x, b.y);                                                        \
        CGContextClosePath(ctx);                                                                       \
        CGContextStrokePath(ctx);                                                                      \
    }

#define drawTriangle(a, b, c, ctx, color)                                                            \
    {                                                                                                \
        CGContextSetRGBFillColor(ctx, color.redComponent, color.greenComponent, color.blueComponent, \
                                 color.alphaComponent);                                              \
        CGContextBeginPath(ctx);                                                                     \
        CGContextMoveToPoint(ctx, a.x, a.y);                                                         \
        CGContextAddLineToPoint(ctx, b.x, b.y);                                                      \
        CGContextAddLineToPoint(ctx, c.x, c.y);                                                      \
        CGContextAddLineToPoint(ctx, a.x, a.y);                                                      \
        CGContextClosePath(ctx);                                                                     \
        CGContextFillPath(ctx);                                                                      \
    }

#define N 500.0F

typedef NS_ENUM(NSInteger, RotateAxis) { RotateAxisX, RotateAxisY, RotateAxisZ };

@interface StageView () {
    int _tx;
    int _ty;

    int _intx;
    int _inty;

    CGFloat _previousRadianX;
    CGFloat _previousRadianY;

    CGPoint _dragPoint;

    //    BoxObject *_box;

    CGFloat _xRotateRadian;
    CGFloat _yRotateRadian;

    NSInteger previousTimestamp;

    FileParser *parser;

    Object3DEntity *_object;

    CGPoint centerPoint;
}

@end

@implementation StageView

- (instancetype)init {
    if (self = [super init]) {
        _dragPoint = CGPointMake(0, 0);
        //        _box = [[BoxObject alloc] initWithLength:150];
    }

    return self;
}

- (void)mouseDown:(NSEvent *)theEvent {
    CGPoint location = theEvent.locationInWindow;

    if (isnan(_dragPoint.x) || isnan(_dragPoint.y)) _dragPoint = CGPointMake(0, 0);
    //    if (!_box) _box = [[BoxObject alloc] initWithLength:150];

    if (!_object) {
        parser = [[FileParser alloc] init];
        parser.delegate = self;
        _object = [parser parse3DSFileWithPath:@"/Users/7heaven/Downloads/Mirror.3DS"];
        //        [parser parseJPEGFileWithPath:@"/Users/7heaven/Downloads/frog.jpg"];
    }

    _intx = location.x;
    _inty = location.y;
}

- (void)fileParser:(FileParser *)fileParser parseProgress:(CGFloat)progress {
    //    NSLog(@"fileParserProgress:%f", progress);
}

- (void)mouseDragged:(NSEvent *)theEvent {
    CGPoint location = theEvent.locationInWindow;

    _tx = location.x - _intx;
    _ty = location.y - _inty;

    _dragPoint = CGPointMake(_dragPoint.x + (_tx - _dragPoint.x) * 0.01, _dragPoint.y + (_ty - _dragPoint.y) * 0.01);

    [self setNeedsDisplay:YES];
    [self needsDisplay];
}

- (void)mouseUp:(NSEvent *)theEvent {
    CGPoint location = theEvent.locationInWindow;

    _previousRadianX = (_tx - centerPoint.x) / 200;
    _previousRadianY = (_ty - centerPoint.y) / 200;
}

- (void)mouseMoved:(NSEvent *)theEvent {
    NSLog(@"mouseMoved:%@", theEvent);
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];

    if (self.delegate && [self.delegate respondsToSelector:@selector(onRateCalculated:)]) {
        NSInteger now = [NSDate date].timeIntervalSince1970 * 1000;
        NSInteger gap = now - previousTimestamp;
        [self.delegate onRateCalculated:gap == 0 ? 0 : 1000 / (now - previousTimestamp)];
        previousTimestamp = now;
    }

    centerPoint = CGPointMake(dirtyRect.size.width / 2, dirtyRect.size.height / 2);

    CGContextRef context = [[NSGraphicsContext currentContext] graphicsPort];

    if (_object) {
        for (int i = 0; i < [_object.triangleArray count]; i++) {
            Triangle3D *triangle = _object.triangleArray[i];

            Vector3D *v0 = _object.vectorArray[triangle.v0Simple];
            Vector3D *v1 = _object.vectorArray[triangle.v1Simple];
            Vector3D *v2 = _object.vectorArray[triangle.v2Simple];

            Vector3D *rv0 = [self rotateVector:Vector3DMake(v0.x, v0.y, v0.z + 600)
                                        radian:(_tx - centerPoint.x) / 200 + _previousRadianX
                                          axis:RotateAxisY];
            rv0 = [self rotateVector:rv0 radian:(_ty - centerPoint.y) / 200 + _previousRadianY axis:RotateAxisX];

            Vector3D *rv1 = [self rotateVector:Vector3DMake(v1.x, v1.y, v1.z + 600)
                                        radian:(_tx - centerPoint.x) / 200 + _previousRadianX
                                          axis:RotateAxisY];
            rv1 = [self rotateVector:rv1 radian:(_ty - centerPoint.y) / 200 + _previousRadianY axis:RotateAxisX];

            Vector3D *rv2 = [self rotateVector:Vector3DMake(v2.x, v2.y, v2.z + 600)
                                        radian:(_tx - centerPoint.x) / 200 + _previousRadianX
                                          axis:RotateAxisY];
            rv2 = [self rotateVector:rv2 radian:(_ty - centerPoint.y) / 200 + _previousRadianY axis:RotateAxisX];

            CGPoint v2d0 = [self perspective:rv0];
            CGPoint v2d1 = [self perspective:rv1];
            CGPoint v2d2 = [self perspective:rv2];

            v2d0 = CGPointMake(v2d0.x + centerPoint.x, v2d0.y + centerPoint.y);
            v2d1 = CGPointMake(v2d1.x + centerPoint.x, v2d1.y + centerPoint.y);
            v2d2 = CGPointMake(v2d2.x + centerPoint.x, v2d2.y + centerPoint.y);

            NSDictionary *crossProduct = [self crossProWithV0:Vector3DMake(rv1.x - rv0.x, rv1.y - rv0.y, rv1.z - rv0.z)
                                                           v1:Vector3DMake(rv2.x - rv0.x, rv2.y - rv0.y, rv2.z - rv0.z)
                                                       center:centerPoint];

            if ([crossProduct[@"z"] floatValue] > 0) continue;

            //            CGPoint vcross0 = CGPointMake(v2d1.x - v2d0.x, v2d1.y - v2d0.y);
            //            CGPoint vcross1 = CGPointMake(v2d2.x - v2d0.x, v2d2.y - v2d0.y);

            //            CGFloat z = vcross0.x * vcross1.y - vcross0.y - vcross1.x;

            //            if (z > 0) continue;

            CGFloat cross = [crossProduct[@"cross"] floatValue];

            if (cross > 1) cross = 1.0f;

            drawTriangle(v2d0, v2d1, v2d2, context,
                         [NSColor colorWithCalibratedRed:1.0F - cross green:1.0F - cross blue:1.0F - cross alpha:1.0F]);

            //            line(v2d0, v2d1, context, color(@"0xFFFF0000"));
            //            line(v2d1, v2d2, context, color(@"0xFFFF0000"));
            //            line(v2d2, v2d0, context, color(@"0xFFFF0000"));
        }
    }
}

- (CGPoint)perspective:(Vector3D *)vector {
    CGFloat x = N * (vector.x / vector.z);
    CGFloat y = N * (vector.y / vector.z);

    return CGPointMake(x, y);
}

- (Vector3D *)rotateVector:(Vector3D *)v radian:(CGFloat)radian axis:(RotateAxis)axis {
    CGFloat cosRadian = cosf(radian);
    CGFloat sinRadian = sinf(radian);

    CGFloat x = v.x;
    CGFloat y = v.y;
    CGFloat z = v.z - 600;

    switch (axis) {
        case RotateAxisX:
            return Vector3DMake(x, cosRadian * y - sinRadian * z, sinRadian * y + cosRadian * z + 600);

        case RotateAxisY:
            return Vector3DMake(cosRadian * x - sinRadian * z, y, sinRadian * x + cosRadian * z + 600);

        case RotateAxisZ:
            return Vector3DMake(cosRadian * x - sinRadian * y, sinRadian * x + cosRadian * y, z);
    }

    return v;
}

- (NSDictionary *)crossProWithV0:(Vector3D *)v0 v1:(Vector3D *)v1 center:(CGPoint)cPoint {
    CGFloat t_x = v0.y * v1.z - v0.z * v1.y;
    CGFloat t_y = v0.z * v1.x - v0.x * v1.z;
    CGFloat t_z = v0.x * v1.y - v0.y * v1.x;

    CGFloat m = sqrt(t_x * t_x + t_y * t_y + t_z * t_z);
    t_x -= m * (cPoint.x - cPoint.x) / cPoint.x;
    t_y -= m * (cPoint.y - cPoint.x) / cPoint.x;
    //向量单位化
    t_x /= m;
    t_y /= m;
    //不开方,以减少运算量
    return @{ @"cross" : @(t_x * t_x + t_y * t_y), @"z" : @(t_z) };
}

- (void)setPixelX:(int)x y:(int)y context:(CGContextRef)context color:(NSColor *)color {
    CGContextSetRGBFillColor(context, color.redComponent, color.greenComponent, color.blueComponent,
                             color.alphaComponent);
    CGContextFillRect(context, CGRectMake(x, y, 10, 10));
}

@end
