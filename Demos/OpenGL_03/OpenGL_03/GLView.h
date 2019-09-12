//
//  GLView.h
//  OpenGL_03
//
//  Created by mediaios on 2019/9/11.
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
    GLuint _programHandle;
    GLint _modelViewSlot;
    GLint _projectionSlot;
}
@end

NS_ASSUME_NONNULL_END
