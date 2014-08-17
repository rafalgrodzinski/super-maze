//
//  Physics.m
//  Super Maze
//
//  Created by Rafał Grodziński on 03.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import "Physics.h"

#import <Super_Maze-Swift.h>
#import "Box2d.h"


@interface Physics ()

@property (nonatomic, strong) Maze *maze;

@property (nonatomic, assign) b2World *world;
@property (nonatomic, assign) b2Body *ball;
@property (nonatomic, assign) b2Body *mazeBody;

@end


@implementation Physics

#pragma mark - Initialization
- (instancetype)initWithMaze:(Maze *)maze_
{
    self = [super init];
    if(self == nil)
        return nil;
    
    self.maze = maze_;
    
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
    self.world = new b2World(b2Vec2_zero);
}


- (void)setupMaze
{
    b2BodyDef mazeDef;
    mazeDef.type = b2_kinematicBody;
    
    self.mazeBody = self.world->CreateBody(&mazeDef);
    
    for(NSInteger level=0; level<self.maze.levelMultipliers.count; level++) {
        //outside walls
        NSArray *outsideWallPolygons = [self.maze ousideWallPolygonsAtLevel:level];
        
        for(Polygon *wallPolygon in outsideWallPolygons) {
            b2Vec2 points[4];
            points[0] = b2Vec2(wallPolygon.v0.x, wallPolygon.v0.y);
            points[1] = b2Vec2(wallPolygon.v1.x, wallPolygon.v1.y);
            points[2] = b2Vec2(wallPolygon.v2.x, wallPolygon.v2.y);
            points[3] = b2Vec2(wallPolygon.v3.x, wallPolygon.v3.y);
            
            b2PolygonShape wallPolygonShape;
            wallPolygonShape.Set(points, 4);
            
            b2FixtureDef wallPolygonFixture;
            wallPolygonFixture.shape = &wallPolygonShape;
            
            self.mazeBody->CreateFixture(&wallPolygonFixture);
        }
        
        //inside walls
        NSArray *wallPolygons = [self.maze wallPolygonsAtLevel:level];
        
        for(Polygon *wallPolygon in wallPolygons) {
            b2Vec2 points[4];
            points[0] = b2Vec2(wallPolygon.v0.x, wallPolygon.v0.y);
            points[1] = b2Vec2(wallPolygon.v1.x, wallPolygon.v1.y);
            points[2] = b2Vec2(wallPolygon.v2.x, wallPolygon.v2.y);
            points[3] = b2Vec2(wallPolygon.v3.x, wallPolygon.v3.y);
            
            b2PolygonShape wallPolygonShape;
            wallPolygonShape.Set(points, 4);
            
            b2FixtureDef wallPolygonFixture;
            wallPolygonFixture.shape = &wallPolygonShape;
            
            self.mazeBody->CreateFixture(&wallPolygonFixture);
        }
    }
}


- (void)setupBall
{
    _ballDiameter = 15.0;

    b2BodyDef ballDef;
    ballDef.type = b2_dynamicBody;
    ballDef.linearDamping = 0.4;
    self.ball = self.world->CreateBody(&ballDef);
    
    b2CircleShape ballShape;
    ballShape.m_radius = self.ballDiameter*0.5;
    ballShape.m_p = b2Vec2(self.ballPosition.x, self.ballPosition.y);
    
    b2FixtureDef ballFixture;
    ballFixture.shape = &ballShape;
    ballFixture.density = 0.1;
    ballFixture.restitution = 0.6;
    
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
    self.ball->ApplyForceToCenter(b2Vec2(rotation_.x*256.0, rotation_.y*256.0), true);
    self.world->Step(interval_, 8, 3);
}

@end
