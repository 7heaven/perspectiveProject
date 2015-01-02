//
//  FileParser.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "FileParser.h"
#import "Vector3D.h"
#import "Triangle3D.h"

#define compareByte(a, b) [a.description isEqualToString:b]

@implementation FileParser

- (Object3DEntity *)parse3DSFileWithPath:(NSString *)path {
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    if (fileData) {
        Object3DEntity *object3D = [[Object3DEntity alloc] init];

        NSUInteger totalBytesCount = [fileData length];

        NSInteger index = 0;

        NSData *byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

        index += 2;

        NSData *chunkLength = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

        index += 4;

        NSInteger totalLength = 0;
        while (index < totalBytesCount) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(fileParser:parseProgress:)]) {
                [self.delegate fileParser:self parseProgress:totalLength > 0 ? (float)index / (float)totalLength : 0];
            }

            int length;

            [chunkLength getBytes:&length length:sizeof(length)];

            if (compareByte(byteData, @"<4d4d>")) {
                [chunkLength getBytes:&totalLength length:sizeof(totalLength)];
                // file header
            } else if (compareByte(byteData, @"<3d3d>")) {
            } else if (compareByte(byteData, @"<0041>")) {
            } else if (compareByte(byteData, @"<0040>")) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                index += 1;

                char size;

                [byteData getBytes:&size length:sizeof(size)];
                while (size != 0) {
                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                    index += 1;

                    if (self.delegate && [self.delegate respondsToSelector:@selector(fileParser:parseProgress:)]) {
                        [self.delegate fileParser:self
                                    parseProgress:totalLength > 0 ? (float)index / (float)totalLength : 0];
                    }

                    [byteData getBytes:&size length:sizeof(size)];
                }

            } else if (compareByte(byteData, @"<1041>")) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

                index += 2;
                short size;
                [byteData getBytes:&size length:sizeof(size)];
                for (int i = 0; i < size; i++) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(fileParser:parseProgress:)]) {
                        [self.delegate fileParser:self
                                    parseProgress:totalLength > 0 ? (float)index / (float)totalLength : 0];
                    }

                    float x, y, z;
                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

                    [byteData getBytes:&x length:sizeof(x)];

                    index += 4;

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

                    [byteData getBytes:&y length:sizeof(y)];

                    index += 4;

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

                    [byteData getBytes:&z length:sizeof(z)];

                    index += 4;

                    [object3D.vectorArray addObject:Vector3DMake(x, y, z)];
                }
            } else if (compareByte(byteData, @"<2041>")) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

                index += 2;

                short size;

                [byteData getBytes:&size length:sizeof(size)];

                for (int i = 0; i < size; i++) {
                    if (self.delegate && [self.delegate respondsToSelector:@selector(fileParser:parseProgress:)]) {
                        [self.delegate fileParser:self
                                    parseProgress:totalLength > 0 ? (float)index / (float)totalLength : 0];
                    }

                    short a, b, c;

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];
                    [byteData getBytes:&a length:sizeof(a)];

                    index += 2;

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];
                    [byteData getBytes:&b length:sizeof(b)];

                    index += 2;

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];
                    [byteData getBytes:&c length:sizeof(c)];

                    index += 4;

                    [object3D.triangleArray addObject:TSimple3DMake(a, b, c)];
                }

            } else if (compareByte(byteData, @"<4041>")) {
                index += length - 6;
            } else {
                index += length - 6;
            }

            byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

            index += 2;

            chunkLength = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

            index += 4;
        }

        return object3D;
    }

    return nil;
}

+ (NSString *)getBitStringForChar:(char)value {
    NSString *bits = @"";

    for (int i = 0; i < 8; i++) {
        bits = [NSString stringWithFormat:@"%i%@", value & (1 << i) ? 1 : 0, bits];
    }

    return bits;
}

@end
