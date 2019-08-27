//
//  OpenGLView.h
//  OpenGL_01
//
//  Created by mediaios on 2019/8/27.
//  Copyright © 2019 mediaios. All rights reserved.
//

#import <UIKit/UIKit.h>
@import OpenGLES;

NS_ASSUME_NONNULL_BEGIN

@interface OpenGLView : UIView
{
    CAEAGLLayer     *_eaglLayer;
    EAGLContext     *_context;
    GLuint          _renderBuffer;
    GLuint          _frameBuffer;
}
@end

NS_ASSUME_NONNULL_END
