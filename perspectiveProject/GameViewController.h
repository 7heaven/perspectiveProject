//
//  GameViewController.h
//  perspectiveProject
//
//  Created by 7heaven on 14/10/29.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import <SceneKit/SceneKit.h>

#import "StageView.h"

@interface GameViewController : NSViewController<StageViewRateDelegate>
@property (strong) IBOutlet StageView *stageView;
@property (weak) IBOutlet NSTextField *rateLabel;

@end
