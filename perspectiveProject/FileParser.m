//
//  FileParser.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <AppKit/AppKit.h>
#import "FileParser.h"
#import "Vector3D.h"
#import "Triangle3D.h"

#define compareByte(a, b) [a.description isEqualToString:b]

typedef struct {
    unsigned char red;
    unsigned char green;
    unsigned char blue;
} HL_RGB;

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

- (NSImage *)parseWebPFileWithPath:(NSString *)path {
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    if (fileData) {
        NSLog(@"fileDataForWebP:%@", fileData);

        NSInteger index = 0;
        NSUInteger totalBytesCount = [fileData length];

        NSData *byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

        index += 4;

        NSLog(@"header_RIFF:%@", [[NSString alloc] initWithData:byteData encoding:NSUTF8StringEncoding]);

        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

        index += 4;

        int fileLength;

        [byteData getBytes:&fileLength length:4];

        NSLog(@"file_size:%dKB", fileLength / 1000);

        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:4];

        index += 4;

        NSLog(@"header_WEBP:%@", [[NSString alloc] initWithData:byteData encoding:NSUTF8StringEncoding]);
    }

    return nil;
}

- (NSImage *)parseJPEGFileWithPath:(NSString *)path {
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    if (fileData) {
        NSLog(@"fileDataForJPEG:%@", fileData);
        NSInteger index = 0;
        NSUInteger totalBytesCount = [fileData length];

        NSData *byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

        index += 2;

        NSData *chunkLength;
        short length = 0;

        while (index < totalBytesCount) {
            NSLog(@"JPEGChunkID:%@", byteData);
            NSLog(@"JPEGChunkLength:%@, length:%hd", chunkLength, length);

            if (compareByte(byteData, @"<ffd8>")) {
            } else if (compareByte(byteData, @"<ffe0>")) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:5];

                index += 5;

                NSLog(@"mark:%@, data:%@", [[NSString alloc] initWithData:byteData encoding:NSUTF8StringEncoding],
                      byteData);

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

                index += 2;

                NSLog(@"version:%@", byteData);

                // skip density info
                index += 5;

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];

                NSLog(@"ori_Width:%@", byteData);

                index += 1;

                int width;

                [byteData getBytes:&width length:1];

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];

                NSLog(@"ori_Height:%@", byteData);

                int height;

                [byteData getBytes:&height length:1];

                index += 1;

                NSLog(@"width:%d, height:%d", width, height);

                index += length - 16;
            } else if (compareByte(byteData, @"<ffe1>")) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:length];

                index += length - 2;

                NSLog(@"ffe1:%@", byteData);
            } else if (compareByte(byteData, @"<ffc0>")) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];

                index += 1;

                NSLog(@"accuracy:%@", byteData);

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

                index += 2;

                short height;

                [[self swapEndian:byteData] getBytes:&height length:2];

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

                index += 2;

                short width;

                [[self swapEndian:byteData] getBytes:&width length:2];

                NSLog(@"width:%hd, height:%hd", width, height);

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];

                index += 1;

                char c;

                [byteData getBytes:&c length:1];

                switch (c) {
                    case 1:
                        NSLog(@"GrayScale");
                        break;
                    case 3:
                        NSLog(@"YCrCb");
                        break;
                    case 4:
                        NSLog(@"CMYK");
                        break;
                }

                index += length - 8;

            } else {
                index += length - 2;
            }

            byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

            index += 2;

            if (!compareByte(byteData, @"<ffd9>")) {
                chunkLength = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

                index += 2;

                [[self swapEndian:chunkLength] getBytes:&length length:sizeof(length)];
            }
        }
    }

    return nil;
}

- (NSImage *)parseGIFFileWithPath:(NSString *)path {
    NSData *fileData = [NSData dataWithContentsOfFile:path];
    //    NSLog(@"fileData:%@", fileData);
    if (fileData) {
        NSInteger index = 0;
        NSUInteger totalBytesCount = [fileData length];

        // pre
        BOOL globalColorTableFlag;
        BOOL globalSortFlag;
        char colorResolution;
        char globalBackgroundColor;

        // read GIF file Header (which is always "GIF")
        NSData *byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:3];

        index += 3;

        NSString *head = [[NSString alloc] initWithData:byteData encoding:NSUTF8StringEncoding];

        NSLog(@"Header:%@", head);

        // read GIF version ("87a" or "89a")
        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:3];

        index += 3;

        NSLog(@"Version:%@", [[NSString alloc] initWithData:byteData encoding:NSUTF8StringEncoding]);

        // gif width
        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

        index += 2;

        short gifWidth;

        [byteData getBytes:&gifWidth length:2];

        // gif height
        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];

        index += 2;

        short gifHeight;

        [byteData getBytes:&gifHeight length:2];

        NSLog(@"width:%d, height:%d", gifWidth, gifHeight);

        // packed field
        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];

        index += 1;

        char packedField;

        [byteData getBytes:&packedField length:1];

        NSLog(@"pixel:%@, real:%f", [FileParser getBitStringForChar:packedField],
              powf(2.0f, (packedField & 0x7) + 1.0f));

        float realPixel = powf(2.0f, (packedField & 0x7) + 1.0f);

        globalColorTableFlag = packedField >> 7 & 0x1;
        globalSortFlag = packedField >> 3 & 0x1;
        colorResolution = packedField >> 4 & 0x7;

        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];

        index += 1;

        [byteData getBytes:&globalBackgroundColor length:1];

        NSLog(@"backgroundColor:%@ , index:%ld", byteData, index);

        // skip width/height ratio
        index += 1;

        // global color table
        NSMutableArray *globalColorTable;

        if (globalColorTableFlag) {
            globalColorTable = [[NSMutableArray alloc] init];

            for (int i = 0; i < realPixel; i++) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:3];
                index += 3;

                HL_RGB rgb;

                unsigned char *bytes = (unsigned char *)[byteData bytes];

                rgb.red = bytes[0];
                rgb.green = bytes[1];
                rgb.blue = bytes[2];

                NSString *colorString = [NSString
                    stringWithFormat:@"0x%@",
                                     [byteData.description
                                         substringWithRange:NSMakeRange(1, [byteData.description length] - 2)]];

                [globalColorTable addObject:[NSValue valueWithBytes:&rgb objCType:@encode(HL_RGB)]];

                //                NSLog(@"%@", colorString);
                //                NSLog(@"index:%d", i);
            }
        }

        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
        index += 1;

        ;

        int imageCount = 0;

        while (index < totalBytesCount) {
            NSLog(@"byteData:%@", byteData);
            // Graphics Control Extension
            if (compareByte(byteData, @"<21>")) {
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                index += 1;
                if (compareByte(byteData, @"<f9>")) {
                    NSLog(@"Graphics Control Extension");
                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];

                    index += 1;

                    unsigned char size;

                    [byteData getBytes:&size length:1];

                    NSLog(@"size:%d", size);

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:size];

                    index += size;

                    NSLog(@"content:%@", byteData);
                }

                if (compareByte(byteData, @"<fe>")) {
                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                    index += 1;

                    while (compareByte(byteData, @"<00>")) {
                        NSLog(@"Comment Extension:%@", byteData);

                        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                        index += 1;
                    }
                }

                if (compareByte(byteData, @"<ff>")) {
                    NSLog(@"Application Extension Block");
                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                    index += 1;

                    unsigned char blockSize;
                    [byteData getBytes:&blockSize length:1];

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:8];
                    index += 8;

                    NSLog(@"application identifier:%@",
                          [[NSString alloc] initWithData:byteData encoding:NSUTF8StringEncoding]);

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:3];
                    index += 3;

                    NSLog(@"application Authentication Code:%@",
                          [[NSString alloc] initWithData:byteData encoding:NSUTF8StringEncoding]);

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                    index++;

                    unsigned char customBlockSize;
                    [byteData getBytes:&customBlockSize length:1];

                    NSLog(@"customBlockSize:%d, ori:%@", customBlockSize, byteData);

                    for (int i = 0; i < customBlockSize; i++) {
                        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                        index += 1;

                        NSLog(@"custom block:%@", byteData);
                    }

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                    index++;
                    if (compareByte(byteData, @"<00>")) {
                        NSLog(@"end of application extension block");
                    }
                }
            }

            // Image Descriptor(main data)
            //----------------------------
            if (compareByte(byteData, @"<2c>")) {
                imageCount++;
                NSLog(@"image descriptor started:%@, index:%ld", byteData, index);

                NSArray *currentColorTable;

                // image left
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];
                index += 2;

                short left;
                [byteData getBytes:&left length:2];

                // image top
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];
                index += 2;

                short top;
                [byteData getBytes:&top length:2];

                // image width
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];
                index += 2;

                short width;
                [byteData getBytes:&width length:2];

                // image height
                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:2];
                index += 2;

                short height;
                [byteData getBytes:&height length:2];

                NSLog(@"imageDescriptor:%d, left:%hd, top:%hd, width:%hd, height:%hd", imageCount, left, top, width,
                      height);

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                index += 1;

                unsigned char packedField;
                [byteData getBytes:&packedField length:1];

                NSLog(@"local_PackedField:%@", [FileParser getBitStringForChar:packedField]);

                BOOL localColorTableFlag = packedField >> 7 & 0x1;
                float localTableLength = powf(2.0f, (packedField & 0x7) + 1.0f);

                BOOL interlaceFlag = packedField >> 6 & 0x1;
                BOOL sortFlag = packedField >> 5 & 0x1;

                NSLog(@"localTableLength:%f", localTableLength);
                NSLog(@"interlaceFlag:%hhd", interlaceFlag);

                NSMutableArray *localColorTable;
                if (localColorTableFlag) {
                    NSLog(@"local_color_table:%d", imageCount);
                    localColorTable = [[NSMutableArray alloc] init];

                    for (int i = 0; i < localTableLength; i++) {
                        byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:3];
                        index += 3;

                        HL_RGB rgb;

                        unsigned char *bytes = (unsigned char *)[byteData bytes];

                        rgb.red = bytes[0];
                        rgb.green = bytes[1];
                        rgb.blue = bytes[2];

                        [localColorTable addObject:[NSValue valueWithBytes:&rgb objCType:@encode(HL_RGB)]];
                    }

                    currentColorTable = [localColorTable copy];
                } else {
                    currentColorTable = [globalColorTable copy];
                }

                byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                index += 1;

                char LZW_MiniCS;
                [byteData getBytes:&LZW_MiniCS length:1];

                NSLog(@"LZM:%@", byteData);

                float lzwSize = 1 << LZW_MiniCS;
                NSMutableDictionary *codeTable = [[NSMutableDictionary alloc] init];
                unsigned int clearCode = (unsigned int)lzwSize;
                unsigned int eoi = clearCode + 0x1;

                for (int i = 0; i < lzwSize; i++) {
                    if (i < [currentColorTable count]) {
                        [codeTable setObject:@[ @(i) ] forKey:@(i)];
                    } else {
                        [codeTable setObject:@[ @(0) ] forKey:@(i)];
                    }
                }

                [codeTable setObject:@[ @(clearCode) ] forKey:@(lzwSize)];
                [codeTable setObject:@[ @(eoi) ] forKey:@(lzwSize + 1)];

                int nextCodeTableIndex = lzwSize + 2;

                unsigned int oldCode = 65535;
                unsigned int newCode;

                int step = 0;

                int codeSizeLimit = LZW_MiniCS + 1;

                unsigned char codeMask = (1 << (codeSizeLimit + 1)) - 1;

                NSMutableArray *indexStream = [[NSMutableArray alloc] init];

                int current = 0;

                int blockCount = 0;
                do {
                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                    index += 1;

                    unsigned char imageBlockSize;
                    [byteData getBytes:&imageBlockSize length:1];

                    NSData *block = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:imageBlockSize];
                    index += imageBlockSize;

                    NSData *singleByte;
                    unsigned char singleChar = '\0';

                    unsigned int k;

                    int blockStep = 0;

                    NSLog(@"block:%@, size:%d", block, imageBlockSize);

                    for (blockStep = 0; blockStep < imageBlockSize;) {
                        newCode = 0;
                        for (int i = 1; i <= codeSizeLimit; i++) {
                            if (i == 1) {
                                singleByte = [NSData dataWithBytes:((char *)[block bytes] + blockStep)length:1];

                                [singleByte getBytes:&singleChar length:1];

                                NSLog(@"step:%d, %d, %@", (singleChar >> step) & 0x1, step, byteData);
                                newCode = (singleChar >> step) & 0x1;

                            } else {
                                NSLog(@"step:%d, %d, %@", (singleChar >> step) & 0x1, step, byteData);
                                newCode |= ((singleChar >> step) & 0x1) << (i - 1);
                            }

                            if (step == 7) {
                                NSLog(@"next");
                                blockStep++;
                                singleByte = [NSData dataWithBytes:((char *)[block bytes] + blockStep)length:1];

                                if (singleByte == nil) break;

                                [singleByte getBytes:&singleChar length:1];
                                step = 0;
                            } else {
                                step++;
                            }

                            if (oldCode == 65535) {
                                oldCode = newCode;
                            }
                        }

                        NSLog(@"newCode:%@, %d", [FileParser getBitStringForChar:newCode], newCode);

                        //                        if (newCode == clearCode) continue;

                        BOOL equals = codeTable[@(newCode)] != nil;

                        if (newCode == clearCode) {
                            NSLog(@"clearCode");
                        } else if (current == 0) {
                            [indexStream addObjectsFromArray:codeTable[@(newCode)]];
                            current = 1;
                        } else if (newCode == eoi) {
                            NSLog(@"eoi:%@", [FileParser getBitStringForChar:newCode]);
                            current = 0;
                            break;
                        } else {
                            if (equals) {
                                k = (unsigned int)[codeTable[@(newCode)][0] intValue];

                                [indexStream addObjectsFromArray:codeTable[@(newCode)]];
                                NSArray *oldCodeK = [codeTable[@(oldCode)] arrayByAddingObject:@(k)];
                                if (oldCodeK) [codeTable setObject:oldCodeK forKey:@(nextCodeTableIndex)];
                                if (nextCodeTableIndex == (1 << codeSizeLimit) - 1) {
                                    NSLog(@"nextCodeTableIndex:%d", nextCodeTableIndex);
                                    codeSizeLimit++;
                                }
                                NSLog(@"newCode:%@ equals", [codeTable[@(oldCode)] arrayByAddingObject:@(k)]);
                                nextCodeTableIndex++;
                            } else {
                                k = (unsigned int)[codeTable[@(oldCode)][0] intValue];

                                NSArray *oldCodeK = [codeTable[@(oldCode)] arrayByAddingObject:@(k)];
                                [indexStream addObjectsFromArray:oldCodeK];
                                if (oldCodeK) [codeTable setObject:oldCodeK forKey:@(nextCodeTableIndex)];
                                if (nextCodeTableIndex == (1 << codeSizeLimit) - 1) {
                                    NSLog(@"nextCodeTableIndex:%d not equals", nextCodeTableIndex);
                                    codeSizeLimit++;
                                }
                                NSLog(@"newCode:%@", oldCodeK);

                                nextCodeTableIndex++;
                            }
                        }

                        oldCode = newCode;

                        NSLog(@"imageBlock:%d, data:%@, index:%ld", blockStep, byteData, index);
                    }

                    byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
                    if (compareByte(byteData, @"<00>")) {
                        NSLog(@"indexStream:%@, count:%ld", indexStream, [indexStream count]);
                        index++;
                        break;
                    }

                    if (false) {
                        if (indexStream && blockCount == 3) {
                            NSLog(@"indexStream:%@, count:%ld", indexStream, [indexStream count]);

                            NSBitmapImageRep *bitmapRep =
                                [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
                                                                        pixelsWide:width
                                                                        pixelsHigh:height
                                                                     bitsPerSample:8
                                                                   samplesPerPixel:3
                                                                          hasAlpha:NO
                                                                          isPlanar:NO
                                                                    colorSpaceName:NSDeviceRGBColorSpace
                                                                       bytesPerRow:width * 3
                                                                      bitsPerPixel:24];

                            NSInteger rowBytes = [bitmapRep bytesPerRow];
                            unsigned char *pix = [bitmapRep bitmapData];

                            NSLog(@"rowBytes:%ld, width:%d, height:%d", rowBytes, width, height);

                            int streamCount = 0;

                            for (int i = 0; i < [indexStream count]; i++) {
                                int streamIndex = [indexStream[i] intValue];

                                NSValue *rgbValue = streamIndex < [currentColorTable count]
                                                        ? currentColorTable[[indexStream[i] intValue]]
                                                        : nil;

                                if (rgbValue) {
                                    HL_RGB rgb;
                                    [rgbValue getValue:&rgb];

                                    pix[i * 3] = rgb.red;
                                    pix[i * 3 + 1] = rgb.green;
                                    pix[i * 3 + 2] = rgb.blue;

                                } else {
                                    pix[i * 3] = globalBackgroundColor;
                                    pix[i * 3 + 1] = globalBackgroundColor;
                                    pix[i * 3 + 2] = globalBackgroundColor;
                                }
                            }

                            NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
                            [image addRepresentation:bitmapRep];
                            return image;
                        }
                    }

                    blockCount++;
                } while (true);

                if (indexStream && imageCount == 1) {
                    NSLog(@"indexStream:%@, count:%ld", indexStream, [indexStream count]);

                    NSBitmapImageRep *bitmapRep =
                        [[NSBitmapImageRep alloc] initWithBitmapDataPlanes:nil
                                                                pixelsWide:width
                                                                pixelsHigh:height
                                                             bitsPerSample:8
                                                           samplesPerPixel:3
                                                                  hasAlpha:NO
                                                                  isPlanar:NO
                                                            colorSpaceName:NSDeviceRGBColorSpace
                                                               bytesPerRow:width * 3
                                                              bitsPerPixel:24];

                    NSInteger rowBytes = [bitmapRep bytesPerRow];
                    unsigned char *pix = [bitmapRep bitmapData];

                    NSLog(@"rowBytes:%ld, width:%d, height:%d", rowBytes, width, height);

                    int streamCount = 0;

                    for (int i = 0; i < [indexStream count]; i++) {
                        int streamIndex = [indexStream[i] intValue];

                        NSValue *rgbValue = streamIndex < [currentColorTable count]
                                                ? currentColorTable[[indexStream[i] intValue]]
                                                : nil;

                        if (rgbValue) {
                            HL_RGB rgb;
                            [rgbValue getValue:&rgb];

                            pix[i * 3] = rgb.red;
                            pix[i * 3 + 1] = rgb.green;
                            pix[i * 3 + 2] = rgb.blue;

                        } else {
                            pix[i * 3] = globalBackgroundColor;
                            pix[i * 3 + 1] = globalBackgroundColor;
                            pix[i * 3 + 2] = globalBackgroundColor;
                        }
                    }

                    //                    if (top > 0 || left > 0 || width < gifWidth || height < gifHeight) {
                    //                        int total = top * gifWidth;
                    //                        for (int i = 0; i < gifWidth * gifHeight; i++) {
                    //                            if (i < total) {
                    //                                pix[i * 3] = globalBackgroundColor;
                    //                                pix[i * 3 + 1] = globalBackgroundColor;
                    //                                pix[i * 3 + 2] = globalBackgroundColor;
                    //                            } else {
                    //                                if (i - total >= [indexStream count]) break;
                    //                                int streamIndex = [indexStream[i - total] intValue];
                    //
                    //                                if (((i + left) % width) < width && ((i + left) % width) >= left)
                    //                                {
                    //                                    NSValue *rgbValue = streamCount < [currentColorTable count]
                    //                                                            ?
                    //                                                            currentColorTable[[indexStream[streamCount]
                    //                                                            intValue]]
                    //                                                            : nil;
                    //
                    //                                    streamCount++;
                    //
                    //                                    HL_RGB rgb;
                    //                                    [rgbValue getValue:&rgb];
                    //
                    //                                    pix[i * 3] = rgb.red;
                    //                                    pix[i * 3 + 1] = rgb.green;
                    //                                    pix[i * 3 + 2] = rgb.blue;
                    //                                } else {
                    //                                    pix[i * 3] = globalBackgroundColor;
                    //                                    pix[i * 3 + 1] = globalBackgroundColor;
                    //                                    pix[i * 3 + 2] = globalBackgroundColor;
                    //                                }
                    //                            }
                    //                        }
                    //                    } else {
                    //                        for (int i = 0; i < [indexStream count]; i++) {
                    //                            int streamIndex = [indexStream[i] intValue];
                    //
                    //                            NSValue *rgbValue = streamIndex < [currentColorTable count]
                    //                                                    ? currentColorTable[[indexStream[i] intValue]]
                    //                                                    : nil;
                    //
                    //                            if (rgbValue) {
                    //                                HL_RGB rgb;
                    //                                [rgbValue getValue:&rgb];
                    //
                    //                                pix[i * 3] = rgb.red;
                    //                                pix[i * 3 + 1] = rgb.green;
                    //                                pix[i * 3 + 2] = rgb.blue;
                    //
                    //                            } else {
                    //                                pix[i * 3] = globalBackgroundColor;
                    //                                pix[i * 3 + 1] = globalBackgroundColor;
                    //                                pix[i * 3 + 2] = globalBackgroundColor;
                    //                            }
                    //                        }
                    //                    }

                    NSImage *image = [[NSImage alloc] initWithSize:NSMakeSize(width, height)];
                    [image addRepresentation:bitmapRep];
                    return image;
                }
            }

            byteData = [NSData dataWithBytes:((char *)[fileData bytes] + index)length:1];
            index += 1;
        }
    }

    return nil;
}

- (NSData *)swapEndian:(NSData *)data {
    NSUInteger totalLength = [data length];

    char buffer[totalLength];

    [data getBytes:buffer length:totalLength];

    char cBuf2[totalLength];

    for (int k = 0; k < totalLength; ++k) {
        cBuf2[k] = buffer[(totalLength - 1) - k];
    }

    return [NSData dataWithBytes:cBuf2 length:totalLength];
}

+ (NSString *)getBitStringForChar:(short)value {
    NSString *bits = @"";

    for (int i = 0; i < 16; i++) {
        bits = [NSString stringWithFormat:@"%i%@", value & (1 << i) ? 1 : 0, bits];
    }

    return bits;
}

@end
