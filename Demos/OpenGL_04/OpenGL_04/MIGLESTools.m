//
//  MIGLESTools.m
//  OpenGL_03
//
//  Created by meidaios on 2019/9/11.
//  Copyright © 2019 meidaios. All rights reserved.
//

#import "MIGLESTools.h"

@implementation MIGLESTools

+ (GLuint)compileShader:(NSString *)name withType:(GLenum)type
{
    NSError *error;
    NSString *shaderString = [NSString  stringWithContentsOfFile:name encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"get shader file error...");
        return 0;
    }
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLen = (int)[shaderString length];
    GLuint shaderHandle = glCreateShader(type);
    if (shaderHandle == 0) {
        NSLog(@"create shader error...");
        return 0;
    }
    
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLen);
    glCompileShader(shaderHandle);
    
    GLint compileSuccess = 0;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLint messageLen = 0;
        glGetShaderiv(shaderHandle, GL_INFO_LOG_LENGTH, &messageLen);
        if (messageLen > 1) {
            char * infoLog = malloc(sizeof(char) * messageLen);
            glGetShaderInfoLog (shaderHandle, messageLen, NULL, infoLog);
            NSLog(@"Error compiling shader:\n%s\n", infoLog );
            free(infoLog);
        }
        glDeleteShader(shaderHandle);
        return 0;
    }
    return shaderHandle;
}

+ (GLuint)loadVertexShader:(NSString *)vPath andFragmentShader:(NSString *)fPath
{
    GLuint vShader = [self compileShader:vPath withType:GL_VERTEX_SHADER];
    if (vShader == 0) {
        return 0;
    }
    
    GLuint fShader = [self compileShader:fPath withType:GL_FRAGMENT_SHADER];
    if (fShader == 0) {
        glDeleteShader(vShader);
        return 0;
    }
    // Create the program object
    GLuint programHandle = glCreateProgram();
    if (programHandle == 0)
        return 0;
    
    glAttachShader(programHandle, vShader);
    glAttachShader(programHandle, fShader);
    
    // Link the program
    glLinkProgram(programHandle);
    
    // Check the link status
    GLint linked;
    glGetProgramiv(programHandle, GL_LINK_STATUS, &linked);
    
    if (!linked) {
        GLint infoLen = 0;
        glGetProgramiv(programHandle, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1){
            char * infoLog = malloc(sizeof(char) * infoLen);
            glGetProgramInfoLog(programHandle, infoLen, NULL, infoLog);
            
            NSLog(@"Error linking program:\n%s\n", infoLog);
            
            free(infoLog);
        }
        
        glDeleteProgram(programHandle );
        return 0;
    }
    
    // Free up no longer needed shader resources
    glDeleteShader(vShader);
    glDeleteShader(fShader);
    return programHandle;
}
@end
