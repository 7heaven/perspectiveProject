//
//  FileParser.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/31.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileParser : NSObject

+(NSMutableArray *) parse3DSFileWithPath:(NSString *) path;

@end
