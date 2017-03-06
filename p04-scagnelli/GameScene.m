//
//  GameScene.m
//  p04-scagnelli
//
//  Created by Eric Scagnelli on 2/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKSpriteNode *ship;
}

-(id)initWithSize:(CGSize)size{
    
    self = [super initWithSize:size];
    if(self){
        NSLog(@"The size of the game scene is %f x %f", size.width, size.height);
        
        self.backgroundColor = [UIColor blackColor];
        
        
#pragma mark - TBD - Game Backgrounds
        
#pragma mark - Setup Sprite for the ship
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"SpaceFlier_sm_1.png"];
        ship.position = CGPointMake(self.frame.size.width * 0.1, CGRectGetMidY(self.frame));
        [self addChild:ship];
        
        
#pragma mark - TBD - Setup the asteroids
        
#pragma mark - TBD - Setup the lasers
        
#pragma mark - TBD - Setup the Accelerometer to move the ship
        
#pragma mark - TBD - Setup the stars to appear as particles
        
#pragma mark - TBD - Start the actual game
        
    }
    return self;
}

-(void)update:(NSTimeInterval)currentTime{
    
}

@end
