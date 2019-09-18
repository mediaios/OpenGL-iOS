//
//  GLView.m
//  OpenGL_05
//
//  Created by mediaios on 2019/9/18.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "GLView.h"
#import "MIGLESTools.h"

@interface GLView()
{
    float _rotateColorCube;
}
@property (nonatomic,strong) CADisplayLink *displayLink;
@end


@implementation GLView

- (void)setup
{
    [self setupLayer];
    [self setupContext];
    [self compileShaders];
    [self setupProjection];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)layoutSubviews
{
    [EAGLContext setCurrentContext:_context];
    glUseProgram(_programHandle);
    [self destoryBuffers];
    [self setupBuffers];
    [self render];
}

+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                     [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking,
                                     kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
}

- (void)destoryBuffers
{
    if (_renderBuffer) {
        glDeleteBuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
    
    if (_frameBuffer) {
        glDeleteBuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
}

- (void)cleanup
{
    [self destoryBuffers];
    if (_programHandle != 0) {
        glDeleteProgram(_programHandle);
        _programHandle = 0;
    }
    if (_context && [EAGLContext currentContext] == _context)
        [EAGLContext setCurrentContext:nil];
    
    _context = nil;
}

- (void)setupContext
{
    if (!_context) {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    NSAssert(_context && [EAGLContext setCurrentContext:_context],@"Failed to initialize OpenGLES 2.0 context");
}

- (void)setupBuffers
{
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _renderBuffer);
}
#pragma mark- About OpenGL ES
- (void)compileShaders
{
    NSString *vShaderPath = [[NSBundle mainBundle] pathForResource:@"VertexShader"
                                                            ofType:@"glsl"];
    NSString *fShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader"
                                                            ofType:@"glsl"];
    _programHandle = [MIGLESTools loadVertexShader:vShaderPath
                                 andFragmentShader:fShaderPath];
    if (_programHandle == 0) {
        NSLog(@"setup program error...");
        return;
    }
    glUseProgram(_programHandle);
    _positionSlot = glGetAttribLocation(_programHandle, "vPosition");
    _colorSlot = glGetAttribLocation(_programHandle, "vSourceColor");
    _modelViewSlot = glGetUniformLocation(_programHandle, "modelView");
    _projectionSlot = glGetUniformLocation(_programHandle, "projection");
}


/**
 设置投影
 */
- (void)setupProjection
{
    float aspect = self.frame.size.width / self.frame.size.height;
    initMatrix(&_projectionMatrix);
    perspectiveMatrix(&_projectionMatrix, 60.0, aspect, 1.0f, 20.0f);
    
    // Load projection matrix
    glUniformMatrix4fv(_projectionSlot, 1, GL_FALSE, (GLfloat*)&_projectionMatrix.m[0][0]);
    glEnable(GL_CULL_FACE);
}

- (void)updateColorCubeTransform
{
    initMatrix(&_modelViewMatrix);
    translateMatrix(&_modelViewMatrix, 0.0, -1.5, -5.5);
    rotateMatrix(&_modelViewMatrix, _rotateColorCube, 0.0, 1.0, 0.0);
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}

- (void)drawColorCube
{
    GLfloat p_w = self.frame.size.height/self.frame.size.width;

    GLfloat vertices[] = {
        -0.5f*p_w, -0.5f, 0.5f, 1.0, 0.0, 0.0, 1.0,     // red
        -0.5f*p_w, 0.5f, 0.5f, 1.0, 1.0, 0.0, 1.0,      // yellow
        0.5f*p_w, 0.5f, 0.5f, 0.0, 0.0, 1.0, 1.0,       // blue
        0.5f*p_w, -0.5f, 0.5f, 1.0, 1.0, 1.0, 1.0,      // white

        0.5f*p_w, -0.5f, -0.5f, 1.0, 1.0, 0.0, 1.0,     // yellow
        0.5f*p_w, 0.5f, -0.5f, 1.0, 0.0, 0.0, 1.0,      // red
        -0.5f*p_w, 0.5f, -0.5f, 1.0, 1.0, 1.0, 1.0,     // white
        -0.5f*p_w, -0.5f, -0.5f, 0.0, 0.0, 1.0, 1.0,    // blue
    };
    
    // 三角形图元
    GLubyte indices[] = {
        // Front face
        0, 3, 2, 0, 2, 1,

        // Back face
        7, 5, 4, 7, 6, 5,

        // Left face
        0, 1, 6, 0, 6, 7,

        // Right face
        3, 4, 5, 3, 5, 2,

        // Up face
        1, 2, 5, 1, 5, 6,

        // Down face
        0, 7, 4, 0, 4, 3
    };
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 7 * sizeof(float), vertices);
    glVertexAttribPointer(_colorSlot, 4, GL_FLOAT, GL_FALSE, 7 * sizeof(float), vertices + 3);
    glEnableVertexAttribArray(_positionSlot);
    glEnableVertexAttribArray(_colorSlot);
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
    glDisableVertexAttribArray(_colorSlot);
}

- (void)render
{
    if (_context == nil)
        return;
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self updateColorCubeTransform];
    [self drawColorCube];
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)autoRotate
{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallBack:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }else{
        [_displayLink invalidate];
        _displayLink = nil;
    }
}

- (void)displayLinkCallBack:(CADisplayLink *)displayLink
{
    _rotateColorCube += displayLink.duration+90;
    [self render];
}


@end
