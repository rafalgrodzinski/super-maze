//
//  MazeRenderer.m
//  Super Maze
//
//  Created by Rafał Grodziński on 19.08.2014.
//  Copyright (c) 2014 UnalignedByte. All rights reserved.
//

#import "MazeRenderer.h"

#import <Metal/Metal.h>
#import <QuartzCore/CAMetalLayer.h>
#import "Super_maze-Swift.h"


@interface MazeRenderer ()

@property (nonatomic, strong) UIView *rendererView;

@property (nonatomic, strong) id<MTLDevice> device;
@property (nonatomic, strong) id<MTLLibrary> library;
@property (nonatomic, strong) id<MTLCommandQueue> queue;
@property (nonatomic, strong) id<MTLRenderPipelineState> pipeState;

@property (nonatomic, strong) dispatch_semaphore_t renderSemaphore;

@end


@implementation MazeRenderer

#pragma mark - Initialization
- (instancetype)initWithMaze:(Maze *)maze_ rendererView:(UIView *)rendererView_
{
    self = [super init];
    if(self == nil)
        return nil;
    
    self.rendererView = rendererView_;
    
    self.device = MTLCreateSystemDefaultDevice();
    self.library = [self.device newDefaultLibrary];
    self.queue = [self.device newCommandQueue];
    
    MTLRenderPipelineDescriptor *pipeDesc = [MTLRenderPipelineDescriptor new];
    id<MTLFunction> vertProg = [self.library newFunctionWithName:@"default_vert"];
    pipeDesc.vertexFunction = vertProg;
    id<MTLFunction> fragProg = [self.library newFunctionWithName:@"default_frag"];
    pipeDesc.fragmentFunction = fragProg;
    pipeDesc.colorAttachments[0].pixelFormat = MTLPixelFormatBGRA8Unorm;
    self.pipeState = [self.device newRenderPipelineStateWithDescriptor:pipeDesc error:nil];
    
    self.renderSemaphore = dispatch_semaphore_create(3);
    
    return self;
}


#pragma mark - Control
- (void)redraw
{
    dispatch_semaphore_wait(self.renderSemaphore, DISPATCH_TIME_FOREVER);
    
    id<CAMetalDrawable> drawable = [(CAMetalLayer *)self.rendererView.layer nextDrawable];
    
    id<MTLCommandBuffer> commandBuffer = [self.queue commandBuffer];
    
    MTLRenderPassDescriptor *passDescriptor = [MTLRenderPassDescriptor new];
    passDescriptor.colorAttachments[0].texture = drawable.texture;
    passDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
    passDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.2, 0.2, 0.2, 1.0);
    
    MTLViewport view = {0.0, 0.0, self.rendererView.frame.size.width*0.25, self.rendererView.frame.size.height*0.25, 0.0, 1.0};
    
    id<MTLRenderCommandEncoder> encoder = [commandBuffer renderCommandEncoderWithDescriptor:passDescriptor];
    [encoder setViewport:view];
    [encoder setRenderPipelineState:self.pipeState];
    [encoder endEncoding];
    
    [commandBuffer presentDrawable:drawable];
    
    __weak MazeRenderer *welf = self;
    [commandBuffer addCompletedHandler:^(id<MTLCommandBuffer> commandBuffer) {
        dispatch_semaphore_signal(welf.renderSemaphore);
    }];
    
    [commandBuffer commit];
}

@end
