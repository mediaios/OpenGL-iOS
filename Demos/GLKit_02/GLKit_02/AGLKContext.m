//
//  AGLKContext.m
//  GLKit_02
//
//  Created by ethan on 2019/12/19.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "AGLKContext.h"

@implementation AGLKContext

- (void)setClearColor:(GLKVector4)clearColor
{
    _clearColor = clearColor;
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    glClearColor(clearColor.r,
                 clearColor.g,
                 clearColor.b,
                 clearColor.a);
}

- (void)clear:(GLbitfield)mask
{
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    glClear(mask);
}

- (void)enable:(GLenum)capability
{
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    glEnable(capability);
}

- (void)disable:(GLenum)capability
{
    NSAssert(self == [[self class] currentContext], @"Receiving context required to be current context");
    glDisable(capability);
}

- (void)setBlenSourceFounction:(GLenum)sfactor destinationFunction:(GLenum)dfactor
{
    glBlendFunc(sfactor, dfactor);
}
@end
