//
//  Physics.m
//  Super Maze
//
//  Created by Rafał Grodziński on 03.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import "Physics.h"

//#import "Maze/Maze-Swift.h"
#import "Box2d.h"


@interface Physics ()

@property (nonatomic, assign) b2World *world;
@property (nonatomic, assign) b2Body *ball;

@end


@implementation Physics

#pragma mark - Initialization
- (instancetype)initWithMaze:(Maze *)maze_
{
    self = [super init];
    if(self == nil)
        return nil;
    
    [self setupWorld];
    [self setupMaze];
    [self setupBall];
    
    return self;
}


- (void)dealloc
{
    free(self.world);
    free(self.ball);
}


- (void)setupWorld
{
    //self.world = new b2World(b2Vec2(0.0, -900.8));
    //self.world->SetAllowSleeping(false);
    
    self.world = new b2World(b2Vec2_zero);
}


- (void)setupMaze
{
    
}


- (void)setupBall
{
    _ballDiameter = 10.0;

    b2BodyDef ballDef;
    ballDef.type = b2_dynamicBody;
    ballDef.angle = (45.0*180.0)/M_PI;
    self.ball = self.world->CreateBody(&ballDef);
    
    b2CircleShape ballShape;
    ballShape.m_radius = self.ballDiameter*0.5;
    ballShape.m_p = b2Vec2(self.ballPosition.x, self.ballPosition.y);
    
    b2FixtureDef ballFixture;
    ballFixture.shape = &ballShape;
    
    self.ball->CreateFixture(&ballFixture);
}


#pragma mark - Properties
- (CGPoint)ballPosition
{
    b2Vec2 ballPosition = self.ball->GetPosition();
    return CGPointMake(ballPosition.x, ballPosition.y);
}


- (CGFloat)ballAngle
{
    CGFloat angleInRadians = self.ball->GetAngle();
    return (angleInRadians * 180.0)/M_PI;
}


#pragma mark - Update
- (void)updateWithInterval:(CGFloat)interval_ rotation:(CGPoint)rotation_
{
    self.ball->ApplyForceToCenter(b2Vec2(rotation_.x, rotation_.y), true);
    self.world->Step(interval_, 8, 3);
}

@end
