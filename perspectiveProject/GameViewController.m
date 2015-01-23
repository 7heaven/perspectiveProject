//
//  GameViewController.m
//  perspectiveProject
//
//  Created by 7heaven on 14/10/29.
//  Copyright (c) 2014年 7heaven. All rights reserved.
//

#import "GameViewController.h"

@implementation GameViewController

- (void)onRateCalculated:(int)ratePerSecond {
    [self.rateLabel setStringValue:[NSString stringWithFormat:@"FPS: %d/s", ratePerSecond]];
}

- (void)awakeFromNib {
    self.stageView.delegate = self;

    [self.testImage setImageScaling:NSImageScaleProportionallyDown];

    FileParser *parser = [[FileParser alloc] init];

    NSImage *image = [parser parseGIFFileWithPath:@"/Users/caifangmao/Downloads/gif/ddd.gif"];

    [self.testImage setImage:image];

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

@end
