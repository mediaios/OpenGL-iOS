//
//  AGLKContext.h
//  GLKit_02
//
//  Created by ethan on 2019/12/19.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import <GLKit/GLKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGLKContext : EAGLContext

@property (nonatomic,assign) GLKVector4 clearColor;

- (void)clear:(GLbitfield)mask;
- (void)enable:(GLenum)capability;
- (void)disable:(GLenum)capability;
- (void)setBlenSourceFounction:(GLenum)sfactor destinationFunction:(GLenum)dfactor;
@end

NS_ASSUME_NONNULL_END
