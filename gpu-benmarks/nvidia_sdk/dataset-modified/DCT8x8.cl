//{"D":5,"d_Dst":0,"d_Src":1,"imageH":3,"imageW":4,"l_H":10,"l_Transpose":7,"l_Transpose[localY + 0]":6,"l_Transpose[localY + modLocalX]":8,"l_V":9,"stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
  /*
 * Copyright 1993-2010 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */

#define BLOCK_SIZE 8

////////////////////////////////////////////////////////////////////////////////
// Hardcoded unrolled fast 8-point (i)DCT routines
////////////////////////////////////////////////////////////////////////////////
#define    C_a 1.3870398453221474618216191915664f  //a = sqrt(2) * cos(1 * pi / 16)
#define    C_b 1.3065629648763765278566431734272f  //b = sqrt(2) * cos(2 * pi / 16)
#define    C_c 1.1758756024193587169744671046113f  //c = sqrt(2) * cos(3 * pi / 16)
#define    C_d 0.78569495838710218127789736765722f //d = sqrt(2) * cos(5 * pi / 16)
#define    C_e 0.54119610014619698439972320536639f //e = sqrt(2) * cos(6 * pi / 16)
#define    C_f 0.27589937928294301233595756366937f //f = sqrt(2) * cos(7 * pi / 16)
#define C_norm 0.35355339059327376220042218105242f //1 / sqrt(8)

inline void DCT8(float *D){
    float X07P = D[hook(5, 0)] + D[hook(5, 7)];
    float X16P = D[hook(5, 1)] + D[hook(5, 6)];
    float X25P = D[hook(5, 2)] + D[hook(5, 5)];
    float X34P = D[hook(5, 3)] + D[hook(5, 4)];

    float X07M = D[hook(5, 0)] - D[hook(5, 7)];
    float X61M = D[hook(5, 6)] - D[hook(5, 1)];
    float X25M = D[hook(5, 2)] - D[hook(5, 5)];
    float X43M = D[hook(5, 4)] - D[hook(5, 3)];

    float X07P34PP = X07P + X34P;
    float X07P34PM = X07P - X34P;
    float X16P25PP = X16P + X25P;
    float X16P25PM = X16P - X25P;

    D[hook(5, 0)] = C_norm * (X07P34PP + X16P25PP);
    D[hook(5, 2)] = C_norm * (C_b * X07P34PM + C_e * X16P25PM);
    D[hook(5, 4)] = C_norm * (X07P34PP - X16P25PP);
    D[hook(5, 6)] = C_norm * (C_e * X07P34PM - C_b * X16P25PM);

    D[hook(5, 1)] = C_norm * (C_a * X07M - C_c * X61M + C_d * X25M - C_f * X43M);
    D[hook(5, 3)] = C_norm * (C_c * X07M + C_f * X61M - C_a * X25M + C_d * X43M);
    D[hook(5, 5)] = C_norm * (C_d * X07M + C_a * X61M + C_f * X25M - C_c * X43M);
    D[hook(5, 7)] = C_norm * (C_f * X07M + C_d * X61M + C_c * X25M + C_a * X43M);
}

inline void IDCT8(float *D){
    float Y04P   = D[hook(5, 0)] + D[hook(5, 4)];
    float Y2b6eP = C_b * D[hook(5, 2)] + C_e * D[hook(5, 6)];

    float Y04P2b6ePP = Y04P + Y2b6eP;
    float Y04P2b6ePM = Y04P - Y2b6eP;
    float Y7f1aP3c5dPP = C_f * D[hook(5, 7)] + C_a * D[hook(5, 1)] + C_c * D[hook(5, 3)] + C_d * D[hook(5, 5)];
    float Y7a1fM3d5cMP = C_a * D[hook(5, 7)] - C_f * D[hook(5, 1)] + C_d * D[hook(5, 3)] - C_c * D[hook(5, 5)];

    float Y04M   = D[hook(5, 0)] - D[hook(5, 4)];
    float Y2e6bM = C_e * D[hook(5, 2)] - C_b * D[hook(5, 6)];

    float Y04M2e6bMP = Y04M + Y2e6bM;
    float Y04M2e6bMM = Y04M - Y2e6bM;
    float Y1c7dM3f5aPM = C_c * D[hook(5, 1)] - C_d * D[hook(5, 7)] - C_f * D[hook(5, 3)] - C_a * D[hook(5, 5)];
    float Y1d7cP3a5fMM = C_d * D[hook(5, 1)] + C_c * D[hook(5, 7)] - C_a * D[hook(5, 3)] + C_f * D[hook(5, 5)];

    D[hook(5, 0)] = C_norm * (Y04P2b6ePP + Y7f1aP3c5dPP);
    D[hook(5, 7)] = C_norm * (Y04P2b6ePP - Y7f1aP3c5dPP);
    D[hook(5, 4)] = C_norm * (Y04P2b6ePM + Y7a1fM3d5cMP);
    D[hook(5, 3)] = C_norm * (Y04P2b6ePM - Y7a1fM3d5cMP);

    D[hook(5, 1)] = C_norm * (Y04M2e6bMP + Y1c7dM3f5aPM);
    D[hook(5, 5)] = C_norm * (Y04M2e6bMM - Y1d7cP3a5fMM);
    D[hook(5, 2)] = C_norm * (Y04M2e6bMM + Y1d7cP3a5fMM);
    D[hook(5, 6)] = C_norm * (Y04M2e6bMP - Y1c7dM3f5aPM);
}



////////////////////////////////////////////////////////////////////////////////
// 8x8 DCT kernels
////////////////////////////////////////////////////////////////////////////////
#define BLOCK_X 32
#define BLOCK_Y 16

__kernel __attribute__((reqd_work_group_size(BLOCK_X, BLOCK_Y / BLOCK_SIZE, 1)))
void DCT8x8(
    __global float *d_Dst,
    __global float *d_Src,
    uint stride,
    uint imageH,
    uint imageW
){
    __local float l_Transpose[BLOCK_Y][BLOCK_X + 1];
    const uint    localX = get_local_id(0);
    const uint    localY = BLOCK_SIZE * get_local_id(1);
    const uint modLocalX = localX & (BLOCK_SIZE - 1);
    const uint   globalX = get_group_id(0) * BLOCK_X + localX;
    const uint   globalY = get_group_id(1) * BLOCK_Y + localY;

    //Process only full blocks
    if( (globalX - modLocalX + BLOCK_SIZE - 1 >= imageW) || (globalY + BLOCK_SIZE - 1 >= imageH) )
        return;

    __local float *l_V = &l_Transpose[hook(7, localY + 0)][hook(6, localX + 0)];
    __local float *l_H = &l_Transpose[hook(7, localY + modLocalX)][hook(8, localX - modLocalX)];
    d_Src += globalY * stride + globalX;
    d_Dst += globalY * stride + globalX;

    float D[8];
    for(uint i = 0; i < BLOCK_SIZE; i++)
        l_V[hook(9, i * (32 + 1))] = d_Src[hook(1, i * stride)];

    for(uint i = 0; i < BLOCK_SIZE; i++)
        D[hook(5, i)] = l_H[hook(10, i)];
    DCT8(D);
    for(uint i = 0; i < BLOCK_SIZE; i++)
        l_H[hook(10, i)] = D[hook(5, i)];

    for(uint i = 0; i < BLOCK_SIZE; i++)
        D[hook(5, i)] = l_V[hook(9, i * (32 + 1))];
    DCT8(D);

    for(uint i = 0; i < BLOCK_SIZE; i++)
        d_Dst[hook(0, i * stride)] = D[hook(5, i)];
}

__kernel __attribute__((reqd_work_group_size(BLOCK_X, BLOCK_Y / BLOCK_SIZE, 1)))
void IDCT8x8(
    __global float *d_Dst,
    __global float *d_Src,
    uint stride,
    uint imageH,
    uint imageW
){
    __local float l_Transpose[BLOCK_Y][BLOCK_X + 1];
    const uint    localX = get_local_id(0);
    const uint    localY = BLOCK_SIZE * get_local_id(1);
    const uint modLocalX = localX & (BLOCK_SIZE - 1);
    const uint   globalX = get_group_id(0) * BLOCK_X + localX;
    const uint   globalY = get_group_id(1) * BLOCK_Y + localY;

    //Process only full blocks
    if( (globalX - modLocalX + BLOCK_SIZE - 1 >= imageW) || (globalY + BLOCK_SIZE - 1 >= imageH) )
        return;

    __local float *l_V = &l_Transpose[hook(7, localY + 0)][hook(6, localX + 0)];
    __local float *l_H = &l_Transpose[hook(7, localY + modLocalX)][hook(8, localX - modLocalX)];
    d_Src += globalY * stride + globalX;
    d_Dst += globalY * stride + globalX;

    float D[8];
    for(uint i = 0; i < BLOCK_SIZE; i++)
        l_V[hook(9, i * (32 + 1))] = d_Src[hook(1, i * stride)];

    for(uint i = 0; i < BLOCK_SIZE; i++)
        D[hook(5, i)] = l_H[hook(10, i)];
    IDCT8(D);
    for(uint i = 0; i < BLOCK_SIZE; i++)
        l_H[hook(10, i)] = D[hook(5, i)];

    for(uint i = 0; i < BLOCK_SIZE; i++)
        D[hook(5, i)] = l_V[hook(9, i * (32 + 1))];
    IDCT8(D);
    for(uint i = 0; i < BLOCK_SIZE; i++)
        d_Dst[hook(0, i * stride)] = D[hook(5, i)];
}


