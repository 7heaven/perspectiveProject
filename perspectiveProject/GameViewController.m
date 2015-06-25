//
//  GameViewController.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/29.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "GameViewController.h"

@interface GameViewController(){
    NSArray *_images;
    int playCount;
}
@end

@implementation GameViewController

- (void)onRateCalculated:(int)ratePerSecond {
    [self.rateLabel setStringValue:[NSString stringWithFormat:@"FPS: %d/s", ratePerSecond]];
}

- (void)awakeFromNib {
    self.stageView.delegate = self;

    [self.testImage setImageScaling:NSImageScaleProportionallyUpOrDown];

    FileParser *parser = [[FileParser alloc] init];
    
//    [parser parseSTLFileWithPath:@"/Users/caifangmao/Downloads/PS3_Stand_Micro.stl"];

    _images = [parser parseGIFFileWithPath:@"/Users/caifangmao/Downloads/gif/132.gif"];

    if(_images.count == 1){
        [self.testImage setImage:_images[0][@"image"]];
    }else{
        playCount = 0;
//        [NSTimer scheduledTimerWithTimeInterval:0.1
//                                         target:self
//                                       selector:@selector(imagePlay)
//                                       userInfo:nil
//                                        repeats:YES];
        
        [self imagePlay];
    }
    
//    [parser parseJPEGFileWithPath:@"/Users/caifangmao/Downloads/Channel_digital_image_CMYK_color.jpg"];

    //    [parser parseWebPFileWithPath:@"/Users/caifangmao/Downloads/image.webp"];
    /*
     // create a new scene
     SCNScene *scene = [SCNScene sceneNamed:@"art.scnassets/ship.dae"];

     // create and add a camera to the scene
     SCNNode *cameraNode = [SCNNode node];
     cameraNode.camera = [SCNCamera camera];
     [scene.rootNode addChildNode:cameraNode];

     // place the camera
     cameraNode.position = SCNVector3Make(0, 0, 15);

     // create and add a light to the scene
     SCNNode *lightNode = [SCNNode node];
     lightNode.light = [SCNLight light];
     lightNode.light.type = SCNLightTypeOmni;
     lightNode.position = SCNVector3Make(0, 10, 10);
     [scene.rootNode addChildNode:lightNode];

     // create and add an ambient light to the scene
     SCNNode *ambientLightNode = [SCNNode node];
     ambientLightNode.light = [SCNLight light];
     ambientLightNode.light.type = SCNLightTypeAmbient;
     ambientLightNode.light.color = [NSColor darkGrayColor];
     [scene.rootNode addChildNode:ambientLightNode];

     // retrieve the ship node
     SCNNode *ship = [scene.rootNode childNodeWithName:@"ship" recursively:YES];

     // animate the 3d object
     CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"rotation"];
     animation.toValue = [NSValue valueWithSCNVector4:SCNVector4Make(0, 1, 0, M_PI*2)];
     animation.duration = 3;
     animation.repeatCount = MAXFLOAT; //repeat forever
     [ship addAnimation:animation forKey:nil];

     // set the scene to the view
     self.gameView.scene = scene;

     // allows the user to manipulate the camera
     self.gameView.allowsCameraControl = YES;

     // show statistics such as fps and timing information
     self.gameView.showsStatistics = YES;

     // configure the view
     self.gameView.backgroundColor = [NSColor blackColor];
     */
}

- (void) imagePlay{
    int delay;
    if(_images && _images.count > 1){
        delay = [_images[playCount][@"delay"] intValue];
        [self.testImage setImage:_images[playCount++][@"image"]];
        
        if(playCount >= _images.count) playCount = 0;
    }
    
    [self performSelector:@selector(imagePlay) withObject:self afterDelay:(float) delay / (float) 100];
}

@end
