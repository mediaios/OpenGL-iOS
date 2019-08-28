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


#pragma mark-Public methods

/**
 显示一个三角形
 */
- (void)showTriangle;

/**
 显示一个长方形
 */
- (void)showRectangle;

/**
 显示一个八边形
 */
- (void)showOctagon;
@end

NS_ASSUME_NONNULL_END
