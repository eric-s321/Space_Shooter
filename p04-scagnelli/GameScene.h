//
//  GameScene.h
//  p04-scagnelli
//
//  Created by Eric Scagnelli on 2/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
@protocol GameScoreDelegate;

@interface GameScene : SKScene

@property (nonatomic, strong) id<GameScoreDelegate>labelDelegate;

-(SKEmitterNode *) loadEmitterNode:(NSString *)fileName;
-(void)startTheGame;
-(void)startMonitoringAcceleration;
-(void)stopMonitoringAcceleration;
-(void)updateShipPositionFromMotionManager;
-(float)randomValueBetween:(float)low andValue:(float)high;
-(void)update:(NSTimeInterval)currentTime;
-(void) checkForCollisions;
-(void)endGame;
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end

@protocol GameScoreDelegate
-(void)scoreChanged:(int)newScore;
-(void)lifeChanged:(int)newLife;
@end
