//
//  ViewController.m
//  Demo_01
//
//  Created by ethan on 2019/8/26.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "ViewController.h"

typedef struct MIVertex
{
    GLKVector3 positionCoords;
}MIVertex;

static const MIVertex vertices[] = {
    {{0.5f,-0.5,0.0f}},
    {{0.5f,0.5,0.0f}},
    {{-0.5,0.5f,0.0f}},
    {{0.5f,-0.5,0.0f}},
    {{-0.5,0.5f,0.0f}},
    {{-0.5,-0.5,0.0f}}
};

@interface ViewController ()
{
    GLuint vertextBufferID;
}

@property (nonatomic,strong) GLKBaseEffect *baseEffect;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    GLKView *view = (GLKView *)self.view;
    NSAssert([view isKindOfClass:[GLKView class]], @"ViewController's View is Not A GLKView");
    // 创建OPenGL ES2.0 上下文
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    // 设置当前上下文
    [EAGLContext setCurrentContext:view.context];
    
    self.baseEffect = [[GLKBaseEffect alloc] init];
    self.baseEffect.useConstantColor = GL_TRUE;  // 使用静态颜色控制
    self.baseEffect.constantColor = GLKVector4Make(1.0f, 1.0f, 1.0f, 1.0f); /// 设置默认绘制颜色，参数分别是 RGBA
    
    // 设置背景色为黑色
    glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
    
    // 生成并绑定缓存数据
    glGenBuffers(1, &vertextBufferID);
    glBindBuffer(GL_ARRAY_BUFFER, vertextBufferID); // 绑定指定标识符的缓存为当前缓存
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertices), vertices, GL_STATIC_DRAW); // 复制定点数据从cpu到gpu
}

/*
 是GLKViewController系统给我们回调的绘制消息，该方法会一直被调用，和display方法一致
 */
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
    [self.baseEffect prepareToDraw];
    
    // clear frame buffer
    glClear(GL_COLOR_BUFFER_BIT);
    
    // 开启对应的定点缓存属性
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    
    // 设置缓存数据指针：设置指针从奠定数组中读取数据
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(MIVertex), NULL);
    
    // 绘图
//    glDrawArrays(GL_TRIANGLES, 0, 6);  // 绘制矩形
    glDrawArrays(GL_TRIANGLES, 0, 3);  // 绘制三角形
    
}

- (void)dealloc
{
    GLKView *view = (GLKView *)self.view;
    [EAGLContext setCurrentContext:view.context];
    if (0 != vertextBufferID) {
        glDeleteBuffers(1,&vertextBufferID);
        vertextBufferID = 0;
    }
    [EAGLContext setCurrentContext:nil];
}


@end
