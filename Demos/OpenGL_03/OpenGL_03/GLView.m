//
//  GLView.m
//  OpenGL_03
//
//  Created by mediaios on 2019/9/11.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "GLView.h"
#import "MIGLESTools.h"

typedef NS_ENUM(NSUInteger, MIGLChangeType) {
    MIGLChangeType_Default,
    MIGLChangeType_X,
    MIGLChangeType_Y,
    MIGLChangeType_Z
};

@interface GLView()
@property (nonatomic,strong) CADisplayLink *displayLink;
@end


@implementation GLView

- (void)setup
{
    [self setupLayer];
    [self setupContext];
    [self compileShaders];
    [self setupProjection];
    [self resetTransform];
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
    [self updateTransform];
    
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
}

- (void)updateTransform
{
    initMatrix(&_modelViewMatrix);
    // 位移
    translateMatrix(&_modelViewMatrix, self.mX, self.mY, self.mZ);
    
    // 旋转
    rotateMatrix(&_modelViewMatrix, self.rotateX, 1.0, 0.0, 0.0);

    // 缩放
    scaleMatrix(&_modelViewMatrix, 1.0, 1.0, self.scaleZ);
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}

- (void)rotateChange:(MIGLChangeType)type
{
    initMatrix(&_modelViewMatrix);
    translateMatrix(&_modelViewMatrix, self.mX, self.mY, self.mZ);
    switch (type) {
        case MIGLChangeType_Default:
        case MIGLChangeType_X:
            rotateMatrix(&_modelViewMatrix, self.rotateX, 1.0, 0.0, 0.0);
            break;
        case MIGLChangeType_Y:
            rotateMatrix(&_modelViewMatrix, self.rotateY, 0.0, 1.0, 0.0);
            break;
        case MIGLChangeType_Z:
            rotateMatrix(&_modelViewMatrix, self.rotateZ, 0.0, 0.0, 1.0);
            break;
            
        default:
            
            break;
    }
    scaleMatrix(&_modelViewMatrix, 1.0, 1.0, self.scaleZ);
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}

- (void)scaleChange:(MIGLChangeType)type
{
    initMatrix(&_modelViewMatrix);
    translateMatrix(&_modelViewMatrix, self.mX, self.mY, self.mZ);
    rotateMatrix(&_modelViewMatrix, self.rotateX, 1.0, 0.0, 0.0);
    
    switch (type) {
        case MIGLChangeType_Default:
        case MIGLChangeType_X:
            scaleMatrix(&_modelViewMatrix, self.scaleX, 1.0, 1.0);
            break;
        case MIGLChangeType_Y:
            scaleMatrix(&_modelViewMatrix, 1.0, self.scaleY, 1.0);
            break;
        case MIGLChangeType_Z:
            scaleMatrix(&_modelViewMatrix, 1.0, 1.0, self.scaleZ);
            break;
            
        default:
            
            break;
    }
    glUniformMatrix4fv(_modelViewSlot, 1, GL_FALSE, (GLfloat*)&_modelViewMatrix.m[0][0]);
}




// 绘制立方体
- (void)drawCube
{    
    GLfloat p_w = 1;
    GLfloat vertices[] = {  // 坐标顶点数组
        0.7f*p_w, 0.7f, 0.0f,
        0.7f*p_w, -0.7f, 0.0f,
        -0.7f*p_w, -0.7f, 0.0f,
        -0.7f*p_w, 0.7f, 0.0f,
        0.35f*p_w, 0.35f,1.0f,
        0.35f*p_w,-0.35f,1.0f,
        -0.35f*p_w,-0.35f,1.0f,
        -0.35f*p_w,0.35f,1.0f
    };
    

    GLubyte indices[] = {      // 顶点索引
        0, 1, 1, 2, 2, 3, 3, 0,
        4, 5, 5, 6, 6, 7, 7, 4,
        0, 4, 1, 5, 2, 6, 3, 7
    };

    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // Draw lines
    glDrawElements(GL_LINES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
}


- (void)render
{
    if (_context == nil)
        return;
    
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Setup viewport
    //
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    [self drawCube];
    
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)triggerDisplayLink
{
    if (_displayLink == nil) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(linkCallBack:)];
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }else{
        [_displayLink invalidate];
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink = nil;
    }
}

- (void)linkCallBack:(CADisplayLink *)displayLink
{
    self.rotateX += displayLink.duration * 90;
}

- (void)resetTransform
{
    if (_displayLink != nil) {
        [_displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _displayLink = nil;
    }
    _mX = 0.0;
    _mY = 0.0;
    _mZ = -5.5;
    
    _scaleZ = 1.0;
    _rotateX = 0.0;
    
    [self updateTransform];
}

- (void)setMX:(float)mX
{
    _mX = mX;
    [self updateTransform];
    [self render];
}

- (void)setMY:(float)mY
{
    _mY = mY;
    [self updateTransform];
    [self render];
}

- (void)setMZ:(float)mZ
{
    _mZ = mZ;
    [self updateTransform];
    [self render];
}

- (void)setRotateX:(float)rotateX
{
    _rotateX = rotateX;
    [self rotateChange:MIGLChangeType_X];
    [self render];
}

- (void)setRotateY:(float)rotateY
{
    _rotateY = rotateY;
   [self rotateChange:MIGLChangeType_Y];
    [self render];
}

- (void)setRotateZ:(float)rotateZ
{
    _rotateZ = rotateZ;
    [self rotateChange:MIGLChangeType_Z];
    [self render];
}

- (void)setScaleX:(float)scaleX
{
    _scaleX = scaleX;
    [self scaleChange:MIGLChangeType_X];
    [self render];
}

- (void)setScaleY:(float)scaleY
{
    _scaleY = scaleY;
    [self scaleChange:MIGLChangeType_Y];
    [self render];
}

- (void)setScaleZ:(float)scaleZ
{
    _scaleZ = scaleZ;
    [self scaleChange:MIGLChangeType_Z];
    [self render];
}



@end
