//
//  GLView.h
//  OpenGL_02
//
//  Created by ethan on 2019/8/27.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import <UIKit/UIKit.h>
@import OpenGLES;

NS_ASSUME_NONNULL_BEGIN

@interface GLView : UIView
{
    CAEAGLLayer *_eaglLayer;
    EAGLContext *_context;
    GLuint       _framebuffer;
    GLuint       _renderbuffer;
    
     CGSize       _oldSize;
}
@end

NS_ASSUME_NONNULL_END
