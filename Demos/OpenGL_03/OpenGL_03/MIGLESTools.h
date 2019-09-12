//
//  MIGLESTools.h
//  OpenGL_03
//
//  Created by meidaios on 2019/9/11.
//  Copyright © 2019 meidaios. All rights reserved.
//

#import <Foundation/Foundation.h>
@import OpenGLES;

NS_ASSUME_NONNULL_BEGIN

@interface MIGLESTools : NSObject


+ (GLuint)loadVertexShader:(NSString *)vPath andFragmentShader:(NSString *)fPath;

@end

NS_ASSUME_NONNULL_END
