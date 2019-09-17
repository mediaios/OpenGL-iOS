//
//  GLView.h
//  OpenGL_03
//
//  Created by mediaios on 2019/9/11.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMatrix.h"
@import OpenGLES;

NS_ASSUME_NONNULL_BEGIN

@interface GLView : UIView
{
    CAEAGLLayer     *_eaglLayer;
    EAGLContext     *_context;
    GLuint          _renderBuffer;
    GLuint          _frameBuffer;
    
    GLuint _programHandle;
    GLuint _positionSlot;
    GLint _modelViewSlot;
    GLint _projectionSlot;
    
    MIMatrix4 _modelViewMatrix;
    MIMatrix4 _projectionMatrix;
    
}
//  定义图形的位置
@property (nonatomic,assign) float mX;
@property (nonatomic,assign) float mY;
@property (nonatomic,assign) float mZ;

// 旋转
@property (nonatomic,assign) float rotateX;
@property (nonatomic,assign) float rotateY;
@property (nonatomic,assign) float rotateZ;

// 缩放
@property (nonatomic,assign) float scaleX;
@property (nonatomic,assign) float scaleY;
@property (nonatomic,assign) float scaleZ;

- (void)render;
- (void)triggerDisplayLink;
- (void)resetTransform;
- (void)cleanup;
@end

NS_ASSUME_NONNULL_END
