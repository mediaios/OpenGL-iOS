//
//  MIMatrix.h
//  OpenGL_03
//
//  Created by mediaios on 2019/9/12.
//  Copyright © 2019 mediaios. All rights reserved.
//

#ifndef MIMatrix_h
#define MIMatrix_h

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#ifndef M_PI
#define M_PI 3.1415926535897932384626433832795f
#endif


typedef struct MIMatrix3
{
    float m[3][3];
}MIMatrix3;

typedef struct MIMatrix4
{
    float m[4][4];
}MIMatrix4;


/**
 实例化单位矩阵

 @param result 单位矩阵的指针
 */
void initMatrix(MIMatrix4 *result);

void translateMatrix(MIMatrix4 *result, float x, float y, float z);

void perspectiveMatrix(MIMatrix4 *result,float fovy, float aspect, float nearZ, float farZ);



void frustum(MIMatrix4 * result, float left, float right, float bottom, float top, float nearZ, float farZ);
void multiplyMatrix(MIMatrix4 * result, const MIMatrix4 *a, const MIMatrix4 *b);

void rotateMatrix(MIMatrix4 *result, float angle, float x, float y, float z);

void scaleMatrix(MIMatrix4 *result, float sx, float sy, float sz);

#endif /* MIMatrix_h */
