//
//  GLView.h
//  OpenGL_01
//
//  Created by mediaios on 2019/8/28.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import <UIKit/UIKit.h>
@import OpenGLES;

NS_ASSUME_NONNULL_BEGIN

@interface GLView : UIView
{
    CAEAGLLayer     *_eaglLayer;
    EAGLContext     *_context;
    GLuint          _renderBuffer;
    GLuint          _frameBuffer;

    GLuint _positionSlot;
}

#pragma mark- 测试直线图元
/**
 三个顶点
 */
- (void)showLinesPoints3;

/**
 四个顶点
 */
- (void)showLinesPoints4;

/**
 八个顶点
 */
- (void)showLinesPoints8;

#pragma mark- 测试三角形图元
/**
 三个顶点
 */
- (void)drawWithPrimitiveTrianglePoints3;


/**
 四个顶点
 */
- (void)drawWithPrimitiveTrianglePoints4;


/**
 八个顶点
 */
- (void)drawWithPrimitiveTrianglePoints8;


#pragma mark- 利用 GL_TRIANGLES三角图元绘图
/**
 绘制三角形
 */
- (void)showTriangle;

/**
 绘制一个长方形
 */
- (void)showRectangle;

/**
 绘制一个八边形
 */
- (void)showOctagon;
@end

NS_ASSUME_NONNULL_END
