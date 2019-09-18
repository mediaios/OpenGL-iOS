//
//  GLView.h
//  OpenGL_04
//
//  Created by mediaios on 2019/9/18.
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

@property (nonatomic,assign) float rotateShoulder;
@property (nonatomic,assign) float rotateElbow;
@end

NS_ASSUME_NONNULL_END
