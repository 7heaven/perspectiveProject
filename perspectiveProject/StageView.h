//
//  StageView.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/29.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FileParser.h"

@protocol StageViewRateDelegate<NSObject>

@optional

- (void)onRateCalculated:(int)ratePerSecond;

@end

@interface StageView : NSView<FileParserDelegate>

@property (weak, nonatomic) id<StageViewRateDelegate> delegate;

@end
