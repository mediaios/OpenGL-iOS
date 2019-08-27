//
//  ViewController.m
//  Demo_02
//
//  Created by ethan on 2019/8/26.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "ViewController.h"

typedef struct MIVertex{
    GLKVector3 positionCoords;
    GLKMatrix2 textureCoords;
}MIVertex;

static const MIVertex vertices[] = {
    {{1.0f,-1,0.0f},{1.0,0.0f}},
    {{1.0f,1.0,0.0f},{1.0f,1.0f}},
    {{-1.0,1.0f,0.0f},{0.0,1.0f}},
    {{1.0f,-1.0,0.0f},{1.0f,0.0f}},
    {{-1.0,1.0f,0.0f},{0.0,1.0f}},
    {{-1.0,-1.0,0.0f},{0.0f,0.0f}}
};

@interface ViewController ()
{
    GLuint vertexBufferId;
}
@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 新建OPenGL上下文
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // 设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f);
    
    //填充VertexArray
    [self fillTexture];
    
    //填充纹理
    [self fillVertexArray];
}

- (void)fillVertexArray
{
    glGenBuffers(1, &vertexBufferId);
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferId);//绑定指定标识符的缓存为当前缓存
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition); // 定点数据缓存
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(MIVertex), NULL+offsetof(MIVertex, positionCoords));
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(MIVertex), NULL + offsetof(MIVertex, textureCoords));
}

- (void)fillTexture{
    //获取图片
    CGImageRef imageRef = [[UIImage imageNamed:@"Demo.jpg"] CGImage];
    
    //通过图片数据产生纹理缓存
    //GLKTextureInfo封装了纹理缓存的信息，包括是否包含MIP贴图
    NSDictionary* options = [NSDictionary dictionaryWithObjectsAndKeys:@(1), GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *textureInfo = [GLKTextureLoader textureWithCGImage:imageRef options:options error:NULL];
    self.baseEffect.texture2d0.name = textureInfo.name;
    self.baseEffect.texture2d0.target = textureInfo.target;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    //清除背景色
    glClearColor(0.0f,0.0f,0.0f,1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    [self.baseEffect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 6);
}


- (void)dealloc{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if ( 0 != vertexBufferId) {
        glDeleteBuffers(1,
                        &vertexBufferId);
        vertexBufferId = 0;
    }
    [EAGLContext setCurrentContext:nil];
}



@end
