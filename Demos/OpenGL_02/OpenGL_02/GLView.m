//
//  GLView.m
//  OpenGL_01
//
//  Created by mediaios on 2019/8/28.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import "GLView.h"

@implementation GLView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
}

- (void)dealloc
{
    if (_frameBuffer) {
        glDeleteBuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    if (_renderBuffer) {
        glDeleteBuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
    _context = nil;
}


#pragma mark- About OpenGL ES

- (void)setup
{
    [self setupLayer];
    [self setupContext];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self compileShaders];
    
    NSError *error;
    NSAssert1([self checkFramebuffer:&error], @"%@",error.userInfo[@"ErrorMessage"]);
}


+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

- (void)setupLayer
{
    _eaglLayer = (CAEAGLLayer *)self.layer;
    _eaglLayer.opaque = YES;
}

- (void)setupContext
{
    if (!_context) {
        _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    }
    NSAssert(_context && [EAGLContext setCurrentContext:_context],@"Failed to initialize OpenGLES 2.0 context");
}

- (void)setupRenderBuffer
{
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
}

- (void)setupFrameBuffer
{
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER, _renderBuffer);
}

- (void)compileShaders
{
    GLuint vertexShader = [self compileShader:@"VertexShader.glsl" withType:GL_VERTEX_SHADER];
    GLuint framentShader = [self compileShader:@"FragmentShader.glsl" withType:GL_FRAGMENT_SHADER];
    GLuint programHandle = glCreateProgram();
    glAttachShader(programHandle, vertexShader);
    glAttachShader(programHandle, framentShader);
    glLinkProgram(programHandle);
    
    GLint linkSuccess;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar message[255];
        glGetShaderInfoLog(programHandle, sizeof(message), 0, &message[0]);
        NSString *messageString = [NSString stringWithUTF8String:message];
        NSLog(@"glGetProgramiv ShaderIngoLog: %@", messageString);
        exit(1);
    }
    glUseProgram(programHandle);
    _positionSlot = glGetAttribLocation(programHandle, "vPosition");
    
}

- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)shaderType
{
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:nil];
    NSError *error;
    NSString *shaderString = [NSString  stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        exit(1);
    }
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLen = (int)[shaderString length];
    GLuint shaderHandle = glCreateShader(shaderType);
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLen);
    glCompileShader(shaderHandle);
    
    GLuint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar message[256];
        glGetShaderInfoLog(shaderHandle, sizeof(message), 0, &message[0]);
        NSString *messageString= [NSString stringWithUTF8String:message];
        NSLog(@"glGetShaderiv ShaderIngoLog: %@", messageString);
        exit(1);
    }
    return shaderHandle;
}


- (void)render:(float*)vertices counts:(GLint)nums mode:(GLenum)mode
{
    glClearColor(0, 1.0, 0, 1.0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // Setup viewport
    //
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // Load the vertex data
    /*
     告诉OpenGL如何解析顶点数据
     */
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    // 渲染图形： 它使用当前激活的着色器，定义的定点属性，以及VBO的定点数据来渲染图元
    glDrawArrays(mode, 0, nums);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (BOOL)checkFramebuffer:(NSError *__autoreleasing *)error {
    // 检查 framebuffer 是否创建成功
    GLenum status = glCheckFramebufferStatus(GL_FRAMEBUFFER);
    NSString *errorMessage = nil;
    BOOL result = NO;
    
    switch (status)
    {
        case GL_FRAMEBUFFER_UNSUPPORTED:
            errorMessage = @"framebuffer不支持该格式";
            result = NO;
            break;
        case GL_FRAMEBUFFER_COMPLETE:
            NSLog(@"framebuffer 创建成功");
            result = YES;
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_MISSING_ATTACHMENT:
            errorMessage = @"Framebuffer不完整 缺失组件";
            result = NO;
            break;
        case GL_FRAMEBUFFER_INCOMPLETE_DIMENSIONS:
            errorMessage = @"Framebuffer 不完整, 附加图片必须要指定大小";
            result = NO;
            break;
        default:
            // 一般是超出GL纹理的最大限制
            errorMessage = @"未知错误 error !!!!";
            result = NO;
            break;
    }
    
    NSLog(@"%@",errorMessage ? errorMessage : @"");
    *error = errorMessage ? [NSError errorWithDomain:@"com.error"
                                                code:status
                                            userInfo:@{@"ErrorMessage" : errorMessage}] : nil;
    
    return result;
}

#pragma mark-Public methods

/*****    线条操作     *****/

- (void)showLinesPoints3
{
    // 三个顶点
    GLfloat vertices[] = {
        -0.5f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    [self render:vertices counts:3 mode:GL_LINES];
    usleep(1000*1000);
    [self render:vertices counts:3 mode:GL_LINE_STRIP];
    usleep(1000*1000);
    [self render:vertices counts:3 mode:GL_LINE_LOOP];
    
    
}

- (void)showLinesPoints4
{
    // 四个顶点
    GLfloat vertices[] = {
        -0.5f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f,
        0.5f,   0.5f, 0.0f,
    };
    [self render:vertices counts:4 mode:GL_LINES];
    usleep(1000*1000);
    [self render:vertices counts:4 mode:GL_LINE_STRIP];
    usleep(1000*1000);
    [self render:vertices counts:4 mode:GL_LINE_LOOP];
}

- (void)showLinesPoints8
{
    // 八边形
    GLfloat p_w = self.frame.size.height/self.frame.size.width;
    GLfloat vertices[] = {
        0.0f,  0.2f,  0.0f,
        0.2f*p_w,  0.1f,  0.0f,
        0.3f*p_w,  0.0f,  0.0f,
        0.2f*p_w,  -0.1f, 0.0f,
        0.0f*p_w,  -0.2f, 0.0f,
        -0.2f*p_w, -0.1f, 0.0f,
        -0.3f*p_w, 0.0f,  0.0f,
        -0.2f*p_w, 0.1f,  0.0f
    };
    [self render:vertices counts:8 mode:GL_LINES];
    usleep(1000*1000);
    [self render:vertices counts:8 mode:GL_LINE_STRIP];
    usleep(1000*1000);
    [self render:vertices counts:8 mode:GL_LINE_LOOP];
}


/*****    图元类型: 三角形     *****/

- (void)drawWithPrimitiveTrianglePoints3
{
    GLfloat vertices[] = {
        -0.5f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    [self render:vertices counts:3 mode:GL_TRIANGLES];
    usleep(1000*1000);
    [self render:vertices counts:3 mode:GL_TRIANGLE_STRIP];
    usleep(1000*1000);
    [self render:vertices counts:3 mode:GL_TRIANGLE_FAN];
}


/**
 四个点
 */
- (void)drawWithPrimitiveTrianglePoints4
{
    // 矩形
    GLfloat vertices[] = {
        -0.5f,  0.5f, 0.0f,
        0.5f,   0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f
    };
    [self render:vertices counts:4 mode:GL_TRIANGLES];
    usleep(1000*1000);
    [self render:vertices counts:4 mode:GL_TRIANGLE_STRIP];
    usleep(1000*1000);
    [self render:vertices counts:4 mode:GL_TRIANGLE_FAN];
}


/**
 八个点
 */
- (void)drawWithPrimitiveTrianglePoints8
{
    GLfloat p_w = self.frame.size.height/self.frame.size.width;
    GLfloat vertices[] = {
        0.0f,  0.2f,  0.0f,
        0.2f*p_w,  0.1f,  0.0f,
        0.3f*p_w,  0.0f,  0.0f,
        0.2f*p_w,  -0.1f, 0.0f,
        0.0f*p_w,  -0.2f, 0.0f,
        -0.2f*p_w, -0.1f, 0.0f,
        -0.3f*p_w, 0.0f,  0.0f,
        -0.2f*p_w, 0.1f,  0.0f
    };
    [self render:vertices counts:8 mode:GL_TRIANGLES];
    usleep(1000*1000);
    [self render:vertices counts:8 mode:GL_TRIANGLE_STRIP];
    usleep(1000*1000);
    [self render:vertices counts:8 mode:GL_TRIANGLE_FAN];
}



- (void)showTriangle
{
    GLfloat vertices[] = {
        -0.5f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    [self render:vertices counts:3 mode:GL_TRIANGLES];
}

- (void)showRectangle
{
    GLfloat vertices[] = {
        -0.5f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f,
        0.5f,   0.5f, 0.0f,
        -0.5f,  0.5f, 0.0f,
        0.5f,  -0.5f, 0.0f
    };
    [self render:vertices counts:6 mode:GL_TRIANGLES];
}

- (void)showOctagon
{
    GLfloat p_w = self.frame.size.height/self.frame.size.width;
    GLfloat vertices[] = {
      0.0f,  0.2f,  0.0f,
      -0.2f*p_w, 0.1f,  0.0f,
      0.2f*p_w,  0.1f,  0.0f,
      0.2f*p_w,  0.1f,  0.0f,
      0.3f*p_w,  0.0f,  0.0f,
      0.2f*p_w,  -0.1f, 0.0f,
      0.2f*p_w,  -0.1f, 0.0f,
      0.0f*p_w,  -0.2f, 0.0f,
      -0.2f*p_w, -0.1f, 0.0f,
      -0.2f*p_w, -0.1f, 0.0f,
      -0.3f*p_w, 0.0f,  0.0f,
      -0.2f*p_w, 0.1f,  0.0f, // 外围三角形绘画结束，接着绘画内部矩形
      -0.2f*p_w, 0.1f,  0.0f,
      -0.2f*p_w,-0.1f,  0.0f,
       0.2f*p_w, -0.1f, 0.0f,
       0.2f*p_w, -0.1f, 0.0f,
       0.2f*p_w,  0.1f, 0.0f,
       -0.2f*p_w, 0.1f, 0.0f
    };
    [self render:vertices counts:18 mode:GL_TRIANGLES];
}

@end
