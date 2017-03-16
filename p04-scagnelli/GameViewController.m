//
//  GameViewController.m
//  p04-scagnelli
//
//  Created by Eric Scagnelli on 2/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"

@implementation GameViewController{
    GameScene *gameScene;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SKView *skView = (SKView *)self.view;
    
    /*
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    */
    
    // Set up game scene and size to the size of the view
    gameScene = [[GameScene alloc] initWithSize:skView.bounds.size];
    gameScene.scaleMode = SKSceneScaleModeAspectFill;
     
    [skView presentScene:gameScene];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
