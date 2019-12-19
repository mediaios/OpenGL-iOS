//
//  AGLVertexAttribArrayBuffer.m
//  GLKit_02
//
//  Created by ethan on 2019/12/19.
//  Copyright © 2019 ucloud. All rights reserved.
//

#import "AGLVertexAttribArrayBuffer.h"

@implementation AGLVertexAttribArrayBuffer

- (id)initWithAttribStride:(GLsizei)stride
          numberOfVertices:(GLsizei)count
                     bytes:(const GLvoid *)dataPtr
                     usage:(GLenum)usage
{
    NSParameterAssert(0 < stride);
    NSAssert((0 < count && NULL != dataPtr) || (0 == count && NULL == dataPtr), @"data must not be NULL or count > 0");
    if (self = [super init]) {
        _stride = stride;
        _bufferSizeBytes = _stride * count;
        glGenBuffers(1, &_name);
        glBindBuffer(GL_ARRAY_BUFFER, self.name);
        glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, usage);
        
        NSAssert(0 != _name, @"Failed to generate name");
    }
    return self;
}

+ (void)drawPreparedArraysWithMode:(GLenum)mode
                  startVertexIndex:(GLint)first
                  numberOfVertices:(GLsizei)count
{
    
}

- (void)prepareToDrawWithAttrib:(GLuint)index
            numberOfCoordinates:(GLint)count
                   attribOffset:(GLsizeiptr)offset
                   shouldEnable:(BOOL)shouldEnable
{
    NSParameterAssert((0 < count) && (count < 4));
    NSParameterAssert(offset < self.stride);
    NSAssert(0 != _name, @"Invalid name");
    
    glBindBuffer(GL_ARRAY_BUFFER,self.name);
    if (shouldEnable) {
        glEnableVertexAttribArray(index);
    }
    glVertexAttribPointer(index, count, GL_FLOAT, GL_FALSE, self.stride, NULL + offset);
}

- (void)drawArrayWithMode:(GLenum)mode
         startVertexIndex:(GLint)offset
         numberOfVertices:(GLsizei)count
{
    NSAssert(self.bufferSizeBytes >= (offset + count)*self.stride, @"Attempt to draw more vertex data than available.");
    glDrawArrays(mode, offset, count);
}

- (void)reinitWithAttribStride:(GLsizei)stride
              numberOfVertices:(GLsizei)count
                         bytes:(const GLvoid *)dataPtr
{
    NSParameterAssert(0 < stride);
    NSParameterAssert(0 < count);
    NSParameterAssert(NULL != dataPtr);
    NSAssert(0 != self.name, @"Invalid name");
    
    _stride = stride;
    _bufferSizeBytes = stride * count;
    
    glBindBuffer(GL_ARRAY_BUFFER, _name);
    glBufferData(GL_ARRAY_BUFFER, _bufferSizeBytes, dataPtr, GL_DYNAMIC_DRAW);
    
}

@end
