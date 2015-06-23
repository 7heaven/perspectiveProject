//
//  GIFProtocol.h
//  perspectiveProject
//
//  Created by 7heaven on 15/6/23.
//  Copyright (c) 2015年 7heaven. All rights reserved.
//

#ifndef __7heaven_GIFProtocol__
#define __7heaven_GIFProtocol__

class GIFProtocol{
public:
    virtual void frameDecoded(void * data, int frameCursor) = 0;
};


#endif
