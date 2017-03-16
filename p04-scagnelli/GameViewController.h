//
//  GameViewController.h
//  p04-scagnelli
//
//  Created by Eric Scagnelli on 2/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "GameScene.h"

@interface GameViewController : UIViewController<GameScoreDelegate>

//@property(strong, nonatomic) IBOutlet GameScene *gameScene;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *lifeLabel;

@end
