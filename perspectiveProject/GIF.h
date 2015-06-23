//
//  GIF.h
//  perspectiveProject
//
//  Created by 7heaven on 15/6/23.
//  Copyright (c) 2015年 7heaven. All rights reserved.
//

#ifndef perspectiveProject_GIF_h
#define perspectiveProject_GIF_h

#define EXTENSION_INTRODUCER 0x21

typedef struct GIF_FILE_HEADER{
    char gif_head[3]; //always 'GIF'
    char version[3]; //either '89a' or '87a'
}GifFileHeader;

typedef struct GIF_LOGICAL_SCREEN_DESCRIPTOR{
    int16_t width;
    int16_t height;
    
    bool global_color_table_flag;            //-
    char color_resolution : 3;               // |__ packed filed
    bool sort_flag;                          // |
    char global_color_table_size : 3;        //-
    
    char background_color_index : 2;
    char pixel_aspect_ratio : 2;
}LogicalScreenDescriptor;

typedef struct GIF_HEADER{
    GifFileHeader *fileHeader;
    
    LogicalScreenDescriptor *descriptor;
}GifHead;

typedef struct GIF_APP_EXTENSION{
    char head; //always equal to EXTENSION_INTRODUCER
    
}ApplicationExtensionBlock;

#endif
