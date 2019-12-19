//
//  ViewController.m
//  GLKit_03
//
//  Created by ethan on 2019/12/19.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "ViewController.h"
#import "AGLKContext.h"
#import "AGLVertexAttribArrayBuffer.h"

@interface GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)paramterID value:(GLuint)value;
@end

@implementation GLKEffectPropertyTexture (AGLKAdditions)

- (void)aglkSetParameter:(GLenum)paramterID value:(GLuint)value
{
    glBindTexture(self.target, self.name);

     // 修改纹理缓存的模式
    glTexParameteri(
       self.target,
       paramterID,
       value);
}

@end



@interface ViewController ()

@end

@implementation ViewController

typedef struct{
    GLKVector3 positionCoords;
    GLKVector2 textureCoords;
}SceneVertex;

static SceneVertex vertices[] = {
     {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}}, // lower left corner
     {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}}, // lower right corner
     {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}}, // upper left corner
};

// Define defualt vertex data to reset vertices when needed
static const SceneVertex defaultVertices[] =
{
   {{-0.5f, -0.5f, 0.0f}, {0.0f, 0.0f}},
   {{ 0.5f, -0.5f, 0.0f}, {1.0f, 0.0f}},
   {{-0.5f,  0.5f, 0.0f}, {0.0f, 1.0f}},
};

static GLKVector3 movementVectors[3] = {
    {-0.02f, -0.01f, 0.0f},
    { 0.01f, -0.005f,0.0f},
    {-0.01f,  0.01f, 0.0f}
};

- (void)updateTextureParameters
{
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_WRAP_S
                                           value:(self.shouldRepeatTexture ? GL_REPEAT : GL_CLAMP_TO_EDGE)];
    
    [self.baseEffect.texture2d0 aglkSetParameter:GL_TEXTURE_MAG_FILTER
                                           value:(self.shouldUseLinearFilter ? GL_LINEAR : GL_NEAREST)];
    
}

- (void)updateAnimatedVertexPositions
{
    if (_shouldAnimate) {
        
        for (int i = 0; i < 3; i++) {
               vertices[i].positionCoords.x += movementVectors[i].x;
               if (vertices[i].positionCoords.x >= 1.0f || vertices[i].positionCoords.x <= -1.0F) {
                   movementVectors[i].x = - movementVectors[i].x;
               }
               vertices[i].positionCoords.y += movementVectors[i].y;
               if(vertices[i].positionCoords.y >= 1.0f ||
                  vertices[i].positionCoords.y <= -1.0f)
               {
                  movementVectors[i].y = -movementVectors[i].y;
               }
               vertices[i].positionCoords.z += movementVectors[i].z;
               if(vertices[i].positionCoords.z >= 1.0f ||
                  vertices[i].positionCoords.z <= -1.0f)
               {
                  movementVectors[i].z = -movementVectors[i].z;
               }
        }
    }
    else{
        for (int i = 0; i < 3; i++) {
            vertices[i].positionCoords.x =
               defaultVertices[i].positionCoords.x;
            vertices[i].positionCoords.y =
               defaultVertices[i].positionCoords.y;
            vertices[i].positionCoords.z =
               defaultVertices[i].positionCoords.z;
        }
    }
    
    for (int i = 0; i < 3; i++) {
        vertices[i].textureCoords.s =
                   (defaultVertices[i].textureCoords.s +
                    _sCoordinateOffset);
    }
}


- (void)update
{
    [self updateAnimatedVertexPositions];
    [self updateTextureParameters];
    
    [_vertexBuffer reinitWithAttribStride:sizeof(SceneVertex)
                         numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
                                    bytes:vertices];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.preferredFramesPerSecond = 60;
    self.shouldAnimate = YES;
    self.shouldRepeatTexture = YES;
    
    GLKView *view = (GLKView *)self.view;
      NSAssert([view isKindOfClass:[GLKView class]],
         @"View controller's view is not a GLKView");
    
    view.context = [[AGLKContext alloc]
         initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    [AGLKContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f,1.0f,1.0f,1.0f);
    
    ((AGLKContext *)view.context).clearColor = GLKVector4Make(0.0f,0.0f,0.0f,1.0f);
    
    // Create vertex buffer containing vertices to draw
    self.vertexBuffer = [[AGLVertexAttribArrayBuffer alloc]
       initWithAttribStride:sizeof(SceneVertex)
       numberOfVertices:sizeof(vertices) / sizeof(SceneVertex)
       bytes:vertices
       usage:GL_DYNAMIC_DRAW];
    
    
    CGImageRef imageRef =
       [[UIImage imageNamed:@"grid.png"] CGImage];
       
    GLKTextureInfo *textureInfo = [GLKTextureLoader
       textureWithCGImage:imageRef
       options:nil
       error:NULL];
    
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   [self.baseEffect prepareToDraw];
   
   // Clear back frame buffer (erase previous drawing)
   [(AGLKContext *)view.context clear:GL_COLOR_BUFFER_BIT];
   
   [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribPosition
      numberOfCoordinates:3
      attribOffset:offsetof(SceneVertex, positionCoords)
      shouldEnable:YES];
   [self.vertexBuffer prepareToDrawWithAttrib:GLKVertexAttribTexCoord0
      numberOfCoordinates:2
      attribOffset:offsetof(SceneVertex, textureCoords)
      shouldEnable:YES];
      
   // Draw triangles using the first three vertices in the
   // currently bound vertex buffer
   [self.vertexBuffer drawArrayWithMode:GL_TRIANGLES
      startVertexIndex:0
      numberOfVertices:3];
}

- (void)viewDidUnload
{
   [super viewDidUnload];
   
   // Make the view's context current
   GLKView *view = (GLKView *)self.view;
   [AGLKContext setCurrentContext:view.context];
    
   // Delete buffers that aren't needed when view is unloaded
   self.vertexBuffer = nil;
   
   // Stop using the context created in -viewDidLoad
   ((GLKView *)self.view).context = nil;
   [EAGLContext setCurrentContext:nil];
}


- (IBAction)takeSCoordinateOffsetFrom:(UISlider *)sender
{
    self.sCoordinateOffset = [sender value];
}
- (IBAction)takeShouldRepeatTextureFrom:(UISwitch *)sender
{
    self.shouldRepeatTexture = [sender isOn];
}
- (IBAction)takeShouldAnimateFrom:(UISwitch *)sender
{
    self.shouldAnimate = [sender isOn];
}
- (IBAction)takeShouldUseLinearFilterFrom:(UISwitch *)sender
{
    self.shouldUseLinearFilter = [sender isOn];
}


@end
