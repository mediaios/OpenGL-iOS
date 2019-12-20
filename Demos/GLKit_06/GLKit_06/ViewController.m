//
//  ViewController.m
//  GLKit_06
//
//  Created by ethan on 2019/12/20.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLKVertexAttribArrayBuffer.h"
#import "sphere.h"

@interface ViewController ()
@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexPositionBuffer;
@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexNormalBuffer;
@property (nonatomic,strong) AGLKVertexAttribArrayBuffer *vertexTextureCoordBuffer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View Controller's view is not a GLKView");
    
    view.drawableDepthFormat = GLKViewDrawableDepthFormat16;
    
    view.context = [[AGLKContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.light0.enabled = GL_TRUE;
    self.baseEffect.light0.diffuseColor = GLKVector4Make(0.7f, 0.7f, 0.7f, 1.0f);
    self.baseEffect.light0.ambientColor = GLKVector4Make(0.2f, 0.2f, 0.2f, 1.0f);
    self.baseEffect.light0.position = GLKVector4Make(1.0f, 0.0f, -0.8f, 0.0f);
    
    CGImageRef imgRef = [[UIImage imageNamed:@"Earth512x256.jpg"] CGImage];
    
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imgRef
                                                               options:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],GLKTextureLoaderOriginBottomLeft, nil]
                                                                 error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
    
    ((AGLKContext *)(view.context)).clearColor = GLKVector4Make(0.0f, 0.0f, 0.0f, 1.0f);
    
    // Create vertex buffers containing vertices to draw
    self.vertexPositionBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                 initWithAttribStride:(3 * sizeof(GLfloat))
                                 numberOfVertices:sizeof(sphereVerts) / (3*sizeof(GLfloat))
                                 bytes:sphereVerts
                                 usage:GL_STATIC_DRAW];
    self.vertexNormalBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                               initWithAttribStride:(3 * sizeof(GLfloat))
                               numberOfVertices:sizeof(sphereNormals) / (3 * sizeof(GLfloat))
                               bytes:sphereNormals
                               usage:GL_STATIC_DRAW];
    self.vertexTextureCoordBuffer = [[AGLKVertexAttribArrayBuffer alloc]
                                     initWithAttribStride:(2 * sizeof(GLfloat))
                                     numberOfVertices:sizeof(sphereTexCoords)/(2 * sizeof(GLfloat))
                                     bytes:sphereTexCoords
                                     usage:GL_STATIC_DRAW];
    
    
    [((AGLKContext *)view.context) enable:GL_DEPTH_TEST];
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    // 清楚后帧缓冲区
    [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT];

    [self.vertexPositionBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
                                   numberOfCoordinates:3
                                          attribOffset:0
                                          shouldEnable:YES];
    [self.vertexNormalBuffer prepareToDrawWithAttrib:GLKVertexAttribNormal
                                 numberOfCoordinates:3
                                        attribOffset:0
                                        shouldEnable:YES];
    [self.vertexTextureCoordBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
                                       numberOfCoordinates:2
                                              attribOffset:0
                                              shouldEnable:YES];

    // Scale the Y coordinate based on the aspect ratio of the
      // view's Layer which matches the screen aspect ratio for
      // this example
      const GLfloat  aspectRatio =
         (GLfloat)view.drawableWidth / (GLfloat)view.drawableHeight;

      self.baseEffect.transform.projectionMatrix =
         GLKMatrix4MakeScale(1.0f, aspectRatio, 1.0f);
    
    [AGLKVertexAttribArrayBuffer drawPreparedArraysWithMode:GL_TRIANGLES
                                          startVertexIndex:0
                                          numberOfVertices:sphereNumVerts];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    GLKView *view = (GLKView *)self.view;
    [AGLKContext setCurrentContext:view.context];
    
    self.vertexPositionBuffer = nil;
    self.vertexNormalBuffer = nil;
    self.vertexTextureCoordBuffer = nil;
    
    ((GLKView *)self.view).context = nil;
    [EAGLContext setCurrentContext:nil];
}

@end
