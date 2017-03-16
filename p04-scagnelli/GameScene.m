//
//  GameScene.m
//  p04-scagnelli
//
//  Created by Eric Scagnelli on 2/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//
//  Most code in this project is heavily based on Sprite Kit Tutorial: Space Shooter
//  Which can be found at https://www.raywenderlich.com/49625/sprite-kit-tutorial-space-shooter
//

#import <CoreMotion/CoreMotion.h>
#import "GameScene.h"
#import "FMMParallaxNode.h"

#define NUM_LIVES 5

@implementation GameScene {
    SKSpriteNode *ship;
    FMMParallaxNode *parallaxNodeBackgrounds;
    FMMParallaxNode *parallaxNodeSpaceDust;
    CMMotionManager *motionManager;
    
    int numAsteroids;
    NSMutableArray *asteroids;
    int asteroidIndex;
    double nextAsteroidSpawnTime;
    
    int numLasers;
    NSMutableArray *lasers;
    int nextLaser;
    
    float laserSpeed;
    int lives;
    int score;
}

-(id)initWithSize:(CGSize)size{
    
    self = [super initWithSize:size];
    if(self){
        numAsteroids = 15;
        numLasers = 10;
        laserSpeed = 1;
        lives = NUM_LIVES;
        
        NSLog(@"The size of the game scene is %f x %f", size.width, size.height);
        
        self.backgroundColor = [UIColor blackColor];
        
        //Make physics body around the screen so the ship cannot fall off.
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        
#pragma mark - Game Backgrounds
        NSArray *backgroundNames = @[@"bg_galaxy.png", @"bg_planetsunrise.png",
                                     @"bg_spacialanomaly.png", @"bg_spacialanomaly2.png"];
        
        CGSize planetSize = CGSizeMake(200, 200);
        parallaxNodeBackgrounds = [[FMMParallaxNode alloc] initWithBackgrounds:backgroundNames size:planetSize pointsPerSecondSpeed:10];
        
        parallaxNodeBackgrounds.position = CGPointMake(size.width/2, size.height/2);
        [parallaxNodeBackgrounds randomizeNodesPositions];
        
        [self addChild:parallaxNodeBackgrounds];
        
        NSArray *secondBackgroundNames = @[@"bg_front_spacedust.png",@"bg_front_spacedust.png"];
        parallaxNodeSpaceDust = [[FMMParallaxNode alloc] initWithBackgrounds:secondBackgroundNames
                                                size:size pointsPerSecondSpeed:25];
        
        parallaxNodeSpaceDust.position = CGPointMake(0, 0);
        [self addChild:parallaxNodeSpaceDust];
        
#pragma mark - Setup Sprite for the ship
        ship = [SKSpriteNode spriteNodeWithImageNamed:@"SpaceFlier_sm_1.png"];
        ship.position = CGPointMake(self.frame.size.width * 0.1, CGRectGetMidY(self.frame));
        
        ship.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:ship.frame.size];
        ship.physicsBody.dynamic = YES; //Subject to collisions and outside forces
        ship.physicsBody.affectedByGravity = NO;
        ship.physicsBody.mass = .02;  //arbitrary mass to make movement feel natural.
        
        
        [self addChild:ship];
        
#pragma mark - TBD - Setup the asteroids
        
        asteroids = [[NSMutableArray alloc] initWithCapacity:numAsteroids];
        
        for(int i = 0; i < numAsteroids; i++){
            SKSpriteNode *asteriod = [SKSpriteNode spriteNodeWithImageNamed:@"asteroid"];
            asteriod.hidden = YES;
            [asteriod setXScale:.5];
            [asteriod setYScale:.5];
            [asteroids addObject:asteriod];
            [self addChild:asteriod];
        }
        
#pragma mark - TBD - Setup the lasers
        lasers = [[NSMutableArray alloc] initWithCapacity:numLasers];
        for(int i = 0; i < numLasers; i++){
            SKSpriteNode *laser = [SKSpriteNode spriteNodeWithImageNamed:@"laserbeam_blue"];
            laser.hidden = YES;
            [lasers addObject:laser];
            [self addChild:laser];
        }
        
        
#pragma mark - Setup the Accelerometer to move the ship
        motionManager = [[CMMotionManager alloc] init];
        
#pragma mark - Setup the stars to appear as particles
        [self addChild:[self loadEmitterNode:@"stars1"]];
        [self addChild:[self loadEmitterNode:@"stars2"]];
        [self addChild:[self loadEmitterNode:@"stars3"]];
        
#pragma mark - Start the actual game
        [self startTheGame];
    }
    return self;
}

-(SKEmitterNode *) loadEmitterNode:(NSString *)fileName{
    NSString *emitterPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"sks"];
    SKEmitterNode *emitterNode = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
    
    emitterNode.particlePosition = CGPointMake(self.size.width/2.0, self.size.height/2.0);
    emitterNode.particlePositionRange = CGVectorMake(self.size.width+100, self.size.height);
    
    return emitterNode;
}

-(void)startTheGame{
    ship.hidden = NO;
    ship.position = CGPointMake(self.frame.size.width * .1, CGRectGetMidY(self.frame));
    score = 0;
    [_labelDelegate scoreChanged:0];
    [_labelDelegate lifeChanged:5];
   
    lives = NUM_LIVES;
    nextAsteroidSpawnTime = 0;
    
    for (SKSpriteNode *asteriod in asteroids){
        asteriod.hidden = YES;
    }
    
    for (SKSpriteNode *laser in lasers) {
        laser.hidden = YES;
    }
    
    [self startMonitoringAcceleration];
}

- (void)startMonitoringAcceleration{
    if (motionManager.accelerometerAvailable) {
        [motionManager startAccelerometerUpdates];
        NSLog(@"accelerometer updates on...");
    }
}

- (void)stopMonitoringAcceleration{
    if (motionManager.accelerometerAvailable && motionManager.accelerometerActive) {
        [motionManager stopAccelerometerUpdates];
        NSLog(@"accelerometer updates off...");
    }
}

- (void)updateShipPositionFromMotionManager{
    CMAccelerometerData* data = motionManager.accelerometerData;
    if (fabs(data.acceleration.x) > 0.2) {
        [ship.physicsBody applyForce:CGVectorMake(0.0, 35 * data.acceleration.x)];
    //    NSLog(@"Acceleration is %f", data.acceleration.x + .5);
    }
}


//Generates a random float between low and high
-(float)randomValueBetween:(float)low andValue:(float)high {
    
    //arc4random()/0xFFFFFFFF gives between 0-1 and then we adjust that accordingly
    return (((float) arc4random() / 0xFFFFFFFFu) * (high - low)) + low;
}

- (void)update:(NSTimeInterval)currentTime{
    [parallaxNodeBackgrounds update:currentTime];
    [parallaxNodeSpaceDust update:currentTime];
    [self updateShipPositionFromMotionManager];
    
    double time = CACurrentMediaTime();
    if(time > nextAsteroidSpawnTime){
        float randSecs = [self randomValueBetween:0.4 andValue:1.0];
        nextAsteroidSpawnTime = randSecs + time;
        
        float yPos = [self randomValueBetween:0 andValue:self.frame.size.height];
        float duration = [self randomValueBetween:4 andValue:10];
        
        SKSpriteNode *asteroid = [asteroids objectAtIndex:asteroidIndex % numAsteroids];
        asteroidIndex++;
        
        [asteroid removeAllActions];
        
        asteroid.position = CGPointMake(self.frame.size.width+asteroid.size.width/2, yPos);
        asteroid.hidden = NO;
        
        //CGPoint location = CGPointMake(-self.frame.size.width-asteroid.size.width, yPos);
        CGPoint location = CGPointMake(0-asteroid.size.width, yPos);
        
        SKAction *moveAction = [SKAction moveTo:location duration:duration];
        SKAction *doneAction = [SKAction runBlock:(dispatch_block_t)^() {
         //   NSLog(@"Done");
            asteroid.hidden = YES;
        }];
        
        SKAction *moveAsteroidActionWithDone = [SKAction sequence:@[moveAction, doneAction]];
        [asteroid runAction:moveAsteroidActionWithDone];
    }
    
    [self checkForCollisions];
    
    if(lives == 0){
        NSLog(@"Calling End Game");
        [self performSelectorOnMainThread:@selector(endGame) withObject:nil waitUntilDone:YES];
        //[self endGame];
    }
    
    /*
    int visibileAsteriods = 0;
    for(SKSpriteNode *asteriod in asteroids){
        if (!asteriod.hidden)
            visibileAsteriods++;
    }
    NSLog(@"%d asteriods visible", visibileAsteriods);
    */
}

-(void) checkForCollisions{
    for (SKSpriteNode *asteriod in asteroids){
        if (asteriod.hidden)
            continue;
        
        for(SKSpriteNode *laser in lasers){
            if(laser.hidden)
                continue;
            
            if([laser intersectsNode:asteriod]){
                NSLog(@"Laser hit asteriod!");
                //Hide the two object that just were destroyed
                laser.hidden = YES;
                asteriod.hidden = YES;
                score += 100;
                [_labelDelegate scoreChanged:score];
                continue;
            }
        }
        
        //The ship hit the asteriod!
        if([ship intersectsNode:asteriod]){
            asteriod.hidden = YES;
            SKAction *blinkShip = [SKAction sequence:@[[SKAction fadeOutWithDuration:.1],
                                                       [SKAction fadeInWithDuration:.1]]];
            SKAction *blinkMultipleTimes = [SKAction repeatAction:blinkShip count:4];
            [ship runAction:blinkMultipleTimes];
            if(!ship.hidden){
                lives--; //Take away one life
                [_labelDelegate lifeChanged:lives];
            }
        }
    }
}

-(void)endGame{
    lives = -1; //Change lives from 0 so endGame does not get called multiple times
    [self removeAllActions];
    [self stopMonitoringAcceleration];
    
    ship.hidden = YES;
    
    SKLabelNode *playAgainLabel = [[SKLabelNode alloc]
                                   initWithFontNamed:@"Avenir"];
    playAgainLabel.name = @"playAgainLabel";
    playAgainLabel.text = @"Play Again?";
    playAgainLabel.position = CGPointMake(self.frame.size.width/2, self.frame.size.height * .5);
    playAgainLabel.fontColor = [UIColor greenColor];
    [self addChild:playAgainLabel];
    
   // SKAction *labelScaleAction = [SKAction scaleTo:1.0 duration:0.5];
    //[playAgainLabel runAction:labelScaleAction];
}

//Called automatically when a touch is sensed
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //NSLog(@"Touched");
    
    for(UITouch *touch in touches){
        SKNode *nodeTouched = [self nodeAtPoint:[touch locationInNode:self]];
        if(nodeTouched != self && [nodeTouched.name isEqualToString:@"playAgainLabel"]){
            NSLog(@"IN IF");
            [nodeTouched removeFromParent];
//            [[self childNodeWithName:@"layAgainLabel"] removeFromParent];
            [self startTheGame];
            return;
        }
    }
    
    //Pick the next laser we've already allocated
    SKSpriteNode *laser = [lasers objectAtIndex:nextLaser % numLasers];
    nextLaser++;
    
    //Put laser at right end of ship
    laser.position = CGPointMake(ship.frame.origin.x + ship.size.width, ship.position.y);
    laser.hidden = NO; //Make laser visible
    [laser removeAllActions];
    
    //Set up laser moving actions
    CGPoint location = CGPointMake(self.frame.size.width, ship.position.y);
    SKAction *moveLaser = [SKAction moveTo:location duration:laserSpeed];
    SKAction *moveComplete = [SKAction runBlock:^{
        laser.hidden = YES;
    }];
    
    SKAction *moveLaserAction = [SKAction sequence:@[moveLaser, moveComplete]];
    [laser runAction:moveLaserAction];
}

@end
