//
//  FileParser.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Object3DEntity.h"

@class FileParser;

@protocol FileParserDelegate<NSObject>
@optional

- (void)fileParser:(FileParser *)fileParser parseProgress:(CGFloat)progress;

@end

@interface FileParser : NSObject

@property (weak, nonatomic) id<FileParserDelegate> delegate;

- (Object3DEntity *)parse3DSFileWithPath:(NSString *)path;

@end
