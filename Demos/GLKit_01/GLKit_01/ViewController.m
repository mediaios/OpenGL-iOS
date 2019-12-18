//
//  ViewController.m
//  GLKit_01
//
//  Created by ethan on 2019/12/18.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "ViewController.h"

typedef struct{
    GLKVector3  positionCoords;
}SceneVertex;

static const SceneVertex vertices[] = {
    {{-0.5f, -0.5f, 0.0f}},
    {{ 0.5f, -0.5f, 0.0f}},
    {{-0.5f,  0.5f, 0.0f}}
};


@interface ViewController ()
{
    GLuint  vertexBufferID; // 顶点缓存
}
@property (nonatomic,strong) GLKBaseEffect *baseEffect;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"View Controller's view is not a GLKView");
    
    EAGLContext *context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.context = context;
    
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;    // 是否使用恒定颜色
    self.baseEffect.constantColor = GLKVector4Make(1.0f,    // Red
                                                   1.0f,    // Green
                                                   1.0f,    // Blue
                                                   1.0f);   // Alpha      // 设置恒定颜色为白色
    
    glClearColor(0.0f,0.0f, 0.0f, 1.0f);   // 设置当前OpenGL ES的上下文的清除颜色--->黑色
    
    // 创建，绑定，初始化一个buffer被存储于GPU
    /**
        为缓存生成独一无二的标识符。
     param1:用于指定要生成的缓存标识符的数量；
     param2:是一个指针，指向生成的标识符的内存保存位置
     */
    glGenBuffers(1, &vertexBufferID);
    
    /**  绑定缓存
            param1: 指定要绑定哪一种类型的缓存，OPENGL2目前只支持两种类型的缓存，GL_ARRAY_BUFFER，GL_ELEMENT_ARRAY_BUFFER，GL_ARRAY_BUFFER用于指定一个顶点属性数组。
            param2: 要绑定的缓存的标识符
     */
    glBindBuffer(GL_ARRAY_BUFFER, vertexBufferID);
    
    /**
     复制应用的顶点数据到当前上下文绑定的顶点缓存中。
        param1: 用于指定要更新的当前上下文中所绑定的是哪一个缓存；
        param2: 指定要复制进这个缓存的字节的数量
        param3: 要复制的字节的地址
        param4: 提示了缓存在未来的运算中可能将会被怎样使用。GL_STATIC_DRAW提示会告诉上下文，缓存中的内容适合复制到GPU控制的内存，因为很少对齐进行修改。GL_DYNAMIC_DRAW会告诉上下文，缓存内的数据会频繁改变，同时提示OpenGL ES 以不同的方式来处理缓存的存储。
     
     */
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW);  // 复制数据到缓存中
    
    
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    /**
    设置当前绑定的帧缓存的像素颜色渲染缓存中的每一个像素的颜色为前面使用glClearcOLOR()函数设定的值。
     */
    glClear(GL_COLOR_BUFFER_BIT);
    
    /**
     启动顶点缓存渲染操作
     */
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    /**
     告诉OpenGL ES 顶点数据在哪里以及怎么解释为每个顶点保存的数据。
     param1: 指示当前绑定的缓存包含每个顶点的位置信息 ；
     param2: 指示每个位置有3个部分
     param3:告诉OpenGL ES每个部分都保存为一个浮点类型的值
     param4:告诉OpenGL ES小数点固定数据是否可以被改变；
     param5:也叫做'步幅'，它指定了每个顶点的保存需要多少个字节
     param6:参数是NULL，表示告诉OpenGL ES可以从当前绑定的顶点缓存的开始位置访问顶点数据
     
     */
    glVertexAttribPointer(GLKVertexAttribPosition,
                          3,
                          GL_FLOAT,
                          GL_FALSE,
                          sizeof(SceneVertex),
                          NULL);
    
    glDrawArrays(GL_TRIANGLES,
                 0,
                 3);
}

- (void)dealloc
{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if (0 != vertexBufferID) {
        glDeleteBuffers(1, &vertexBufferID);
        vertexBufferID = 0;
    }
    ((GLKView *)(self.view)).context = nil;
    [EAGLContext setCurrentContext:nil];
}


@end
