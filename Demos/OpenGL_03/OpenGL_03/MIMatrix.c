//
//  MIMatrix.c
//  OpenGL_03
//
//  Created by ethan on 2019/9/12.
//  Copyright © 2019 ucloud. All rights reserved.
//

#include "MIMatrix.h"

void * memcpy(void *, const void *, size_t);
void * memset(void *, int, size_t);

//实例化单位矩阵
void initMatrix(MIMatrix4 *result)
{
    memset(result,0x0,sizeof(MIMatrix4));
    result->m[0][0] = 1.0f;
    result->m[1][1] = 1.0f;
    result->m[2][2] = 1.0f;
    result->m[3][3] = 1.0f;
}

void translateMatrix(MIMatrix4 *result, float x, float y, float z)
{
    result->m[3][0] += (result->m[0][0] * x + result->m[1][0] * y + result->m[2][0] * z);
    result->m[3][1] += (result->m[0][1] * x + result->m[1][1] * y + result->m[2][1] * z);
    result->m[3][2] += (result->m[0][2] * x + result->m[1][2] * y + result->m[2][2] * z);
    result->m[3][3] += (result->m[0][3] * x + result->m[1][3] * y + result->m[2][3] * z);
}

void perspectiveMatrix(MIMatrix4 *result,float fovy, float aspect, float nearZ, float farZ)
{
    float frustumW, frustumH;

    frustumH = tanf( fovy / 360.0f * M_PI ) * nearZ;
    frustumW = frustumH * aspect;

    frustum(result, -frustumW, frustumW, -frustumH, frustumH, nearZ, farZ);
}

void frustum(MIMatrix4 * result, float left, float right, float bottom, float top, float nearZ, float farZ)
{
    float       deltaX = right - left;
    float       deltaY = top - bottom;
    float       deltaZ = farZ - nearZ;
    MIMatrix4    frust;

    if ( (nearZ <= 0.0f) || (farZ <= 0.0f) ||
        (deltaX <= 0.0f) || (deltaY <= 0.0f) || (deltaZ <= 0.0f) )
        return;

    frust.m[0][0] = 2.0f * nearZ / deltaX;
    frust.m[0][1] = frust.m[0][2] = frust.m[0][3] = 0.0f;

    frust.m[1][1] = 2.0f * nearZ / deltaY;
    frust.m[1][0] = frust.m[1][2] = frust.m[1][3] = 0.0f;

    frust.m[2][0] = (right + left) / deltaX;
    frust.m[2][1] = (top + bottom) / deltaY;
    frust.m[2][2] = -(nearZ + farZ) / deltaZ;
    frust.m[2][3] = -1.0f;

    frust.m[3][2] = -2.0f * nearZ * farZ / deltaZ;
    frust.m[3][0] = frust.m[3][1] = frust.m[3][3] = 0.0f;

    multiplyMatrix(result, &frust, result);
}

void multiplyMatrix(MIMatrix4 * result, const MIMatrix4 *a, const MIMatrix4 *b)
{
    MIMatrix4 tmp;
    int i;

    for (i = 0; i < 4; i++)
    {
        tmp.m[i][0] = (a->m[i][0] * b->m[0][0]) +
        (a->m[i][1] * b->m[1][0]) +
        (a->m[i][2] * b->m[2][0]) +
        (a->m[i][3] * b->m[3][0]) ;

        tmp.m[i][1] = (a->m[i][0] * b->m[0][1]) +
        (a->m[i][1] * b->m[1][1]) +
        (a->m[i][2] * b->m[2][1]) +
        (a->m[i][3] * b->m[3][1]) ;

        tmp.m[i][2] = (a->m[i][0] * b->m[0][2]) +
        (a->m[i][1] * b->m[1][2]) +
        (a->m[i][2] * b->m[2][2]) +
        (a->m[i][3] * b->m[3][2]) ;

        tmp.m[i][3] = (a->m[i][0] * b->m[0][3]) +
        (a->m[i][1] * b->m[1][3]) +
        (a->m[i][2] * b->m[2][3]) +
        (a->m[i][3] * b->m[3][3]) ;
    }

    memcpy(result, &tmp, sizeof(MIMatrix4));
}

void rotateMatrix(MIMatrix4 *result, float angle, float x, float y, float z)
{
    float sinAngle, cosAngle;
    float mag = sqrtf(x * x + y * y + z * z);

    sinAngle = sinf ( angle * M_PI / 180.0f );
    cosAngle = cosf ( angle * M_PI / 180.0f );
    if ( mag > 0.0f )
    {
        float xx, yy, zz, xy, yz, zx, xs, ys, zs;
        float oneMinusCos;
        MIMatrix4 rotMat;

        x /= mag;
        y /= mag;
        z /= mag;

        xx = x * x;
        yy = y * y;
        zz = z * z;
        xy = x * y;
        yz = y * z;
        zx = z * x;
        xs = x * sinAngle;
        ys = y * sinAngle;
        zs = z * sinAngle;
        oneMinusCos = 1.0f - cosAngle;

        rotMat.m[0][0] = (oneMinusCos * xx) + cosAngle;
        rotMat.m[0][1] = (oneMinusCos * xy) - zs;
        rotMat.m[0][2] = (oneMinusCos * zx) + ys;
        rotMat.m[0][3] = 0.0F;

        rotMat.m[1][0] = (oneMinusCos * xy) + zs;
        rotMat.m[1][1] = (oneMinusCos * yy) + cosAngle;
        rotMat.m[1][2] = (oneMinusCos * yz) - xs;
        rotMat.m[1][3] = 0.0F;

        rotMat.m[2][0] = (oneMinusCos * zx) - ys;
        rotMat.m[2][1] = (oneMinusCos * yz) + xs;
        rotMat.m[2][2] = (oneMinusCos * zz) + cosAngle;
        rotMat.m[2][3] = 0.0F;

        rotMat.m[3][0] = 0.0F;
        rotMat.m[3][1] = 0.0F;
        rotMat.m[3][2] = 0.0F;
        rotMat.m[3][3] = 1.0F;

        multiplyMatrix( result, &rotMat, result);
    }
}
