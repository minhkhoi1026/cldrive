//{"activeVoxels":10,"compactedVoxelArray":2,"field":18,"gridSize":5,"gridSizeMask":7,"gridSizeShift":6,"isoValue":9,"maxVerts":11,"norm":1,"numVertsScanned":3,"numVertsTex":12,"numVoxels":3,"pos":0,"triTex":13,"v":19,"vertlist":20,"volume":4,"voxelOccupied":1,"voxelOccupiedScan":2,"voxelSize":8,"voxelVerts":0}
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

// #include "defines.h"
// #include "tables.h"


// The number of threads to use for triangle generation (limited by shared memory size)
#define NTHREADS 32

// volume data
sampler_t volumeSampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;
sampler_t tableSampler = CLK_NORMALIZED_COORDS_FALSE | CLK_ADDRESS_CLAMP_TO_EDGE | CLK_FILTER_NEAREST;


// compute position in 3d grid from 1d index
// only works for power of 2 sizes
int4 calcGridPos(uint i, uint4 gridSizeShift, uint4 gridSizeMask)
{
    int4 gridPos;
    gridPos.x = (i & gridSizeMask.x);
    gridPos.y = ((i >> gridSizeShift.y) & gridSizeMask.y);
    gridPos.z = ((i >> gridSizeShift.z) & gridSizeMask.z);
    return gridPos;
}

// classify voxel based on number of vertices it will generate
// one thread per voxel
__kernel
void
classifyVoxel(__global uint* voxelVerts, __global uint *voxelOccupied, __read_only image3d_t volume,
              uint4 gridSize, uint4 gridSizeShift, uint4 gridSizeMask, uint numVoxels,
              float4 voxelSize, float isoValue,  __read_only image2d_t numVertsTex)
{
    uint blockId = get_group_id(0);
    uint i = get_global_id(0);

    int4 gridPos = calcGridPos(i, gridSizeShift, gridSizeMask);

    // read field values at neighbouring grid vertices
    float field[8];
    field[hook(18, 0)] = read_imagef(volume, volumeSampler, gridPos).x;
    field[hook(18, 1)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 0, 0 ,0)).x;
    field[hook(18, 2)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 1, 0,0)).x;
    field[hook(18, 3)] = read_imagef(volume, volumeSampler, gridPos + (int4)(0, 1, 0,0)).x;
    field[hook(18, 4)] = read_imagef(volume, volumeSampler, gridPos + (int4)(0, 0, 1,0)).x;
    field[hook(18, 5)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 0, 1,0)).x;
    field[hook(18, 6)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 1, 1,0)).x;
    field[hook(18, 7)] = read_imagef(volume, volumeSampler, gridPos + (int4)(0, 1, 1,0)).x;

    // calculate flag indicating if each vertex is inside or outside isosurface
    int cubeindex;
	cubeindex =  (field[hook(18, 0)] < isoValue); 
	cubeindex += (field[hook(18, 1)] < isoValue)*2; 
	cubeindex += (field[hook(18, 2)] < isoValue)*4; 
	cubeindex += (field[hook(18, 3)] < isoValue)*8; 
	cubeindex += (field[hook(18, 4)] < isoValue)*16; 
	cubeindex += (field[hook(18, 5)] < isoValue)*32; 
	cubeindex += (field[hook(18, 6)] < isoValue)*64; 
	cubeindex += (field[hook(18, 7)] < isoValue)*128;

    // read number of vertices from texture
    uint numVerts = read_imageui(numVertsTex, tableSampler, (int2)(cubeindex,0)).x;

    if (i < numVoxels) {
        voxelVerts[hook(0, i)] = numVerts;
        voxelOccupied[hook(1, i)] = (numVerts > 0);
    }
}
     

// compact voxel array
__kernel
void
compactVoxels(__global uint *compactedVoxelArray, __global uint *voxelOccupied, __global uint *voxelOccupiedScan, uint numVoxels)
{
    uint i = get_global_id(0);

    if (voxelOccupied[hook(1, i)] && (i < numVoxels)) {
        compactedVoxelArray[ hook(2, voxelOccupiedScan[hook(2, i)])] = i;
    }
}



// compute interpolated vertex along an edge
float4 vertexInterp(float isolevel, float4 p0, float4 p1, float f0, float f1)
{
    float t = (isolevel - f0) / (f1 - f0);
	return mix(p0, p1, t);
} 

// compute interpolated vertex position and normal along an edge
void vertexInterp2(float isolevel, float4 p0, float4 p1, float4 f0, float4 f1, float4* p, float4* n)
{
    float t = (isolevel - f0.w) / (f1.w - f0.w);
	*p = mix(p0, p1, t);
    (*n).x = mix(f0.x, f1.x, t);
    (*n).y = mix(f0.y, f1.y, t);
    (*n).z = mix(f0.z, f1.z, t);
//    n = normalize(n);
} 



// calculate triangle normal
float4 calcNormal(float4 v0, float4 v1, float4 v2)
{
    float4 edge0 = v1 - v0;
    float4 edge1 = v2 - v0;
    // note - it's faster to perform normalization in vertex shader rather than here
    return cross(edge0, edge1);
}

// version that calculates flat surface normal for each triangle
__kernel
void
generateTriangles2(__global float4 *pos, __global float4 *norm, __global uint *compactedVoxelArray, __global uint *numVertsScanned, 
                   __read_only image3d_t volume,
                   uint4 gridSize, uint4 gridSizeShift, uint4 gridSizeMask,
                   float4 voxelSize, float isoValue, uint activeVoxels, uint maxVerts, 
                   __read_only image2d_t numVertsTex, __read_only image2d_t triTex)
{
    uint i = get_global_id(0);
    uint tid = get_local_id(0);

    if (i > activeVoxels - 1) {
        i = activeVoxels - 1;
    }

    uint voxel = compactedVoxelArray[hook(2, i)];

    // compute position in 3d grid
    int4 gridPos = calcGridPos(voxel, gridSizeShift, gridSizeMask);

    float4 p;
    p.x = -1.0f + (gridPos.x * voxelSize.x);
    p.y = -1.0f + (gridPos.y * voxelSize.y);
    p.z = -1.0f + (gridPos.z * voxelSize.z);
    p.w = 1.0f;

    // calculate cell vertex positions
    float4 v[8];
    v[hook(19, 0)] = p;
    v[hook(19, 1)] = p + (float4)(voxelSize.x, 0, 0,0);
    v[hook(19, 2)] = p + (float4)(voxelSize.x, voxelSize.y, 0,0);
    v[hook(19, 3)] = p + (float4)(0, voxelSize.y, 0,0);
    v[hook(19, 4)] = p + (float4)(0, 0, voxelSize.z,0);
    v[hook(19, 5)] = p + (float4)(voxelSize.x, 0, voxelSize.z,0);
    v[hook(19, 6)] = p + (float4)(voxelSize.x, voxelSize.y, voxelSize.z,0);
    v[hook(19, 7)] = p + (float4)(0, voxelSize.y, voxelSize.z,0);

    float field[8];
    field[hook(18, 0)] = read_imagef(volume, volumeSampler, gridPos).x;
    field[hook(18, 1)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 0, 0 ,0)).x;
    field[hook(18, 2)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 1, 0,0)).x;
    field[hook(18, 3)] = read_imagef(volume, volumeSampler, gridPos + (int4)(0, 1, 0,0)).x;
    field[hook(18, 4)] = read_imagef(volume, volumeSampler, gridPos + (int4)(0, 0, 1,0)).x;
    field[hook(18, 5)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 0, 1,0)).x;
    field[hook(18, 6)] = read_imagef(volume, volumeSampler, gridPos + (int4)(1, 1, 1,0)).x;
    field[hook(18, 7)] = read_imagef(volume, volumeSampler, gridPos + (int4)(0, 1, 1,0)).x;

    // recalculate flag
    int cubeindex;
	cubeindex =  (field[hook(18, 0)] < isoValue); 
	cubeindex += (field[hook(18, 1)] < isoValue)*2; 
	cubeindex += (field[hook(18, 2)] < isoValue)*4; 
	cubeindex += (field[hook(18, 3)] < isoValue)*8; 
	cubeindex += (field[hook(18, 4)] < isoValue)*16; 
	cubeindex += (field[hook(18, 5)] < isoValue)*32; 
	cubeindex += (field[hook(18, 6)] < isoValue)*64; 
	cubeindex += (field[hook(18, 7)] < isoValue)*128;

	// find the vertices where the surface intersects the cube 
	__local float4 vertlist[16*NTHREADS];

	vertlist[hook(20, tid)] = vertexInterp(isoValue, v[hook(19, 0)], v[hook(19, 1)], field[hook(18, 0)], field[hook(18, 1)]);
    vertlist[NTHREADS+tid] = vertexInterp(isoValue, v[hook(19, 1)], v[hook(19, 2)], field[hook(18, 1)], field[hook(18, 2)]);
    vertlist[hook(20, (32 * 2) + tid)] = vertexInterp(isoValue, v[hook(19, 2)], v[hook(19, 3)], field[hook(18, 2)], field[hook(18, 3)]);
    vertlist[hook(20, (32 * 3) + tid)] = vertexInterp(isoValue, v[hook(19, 3)], v[hook(19, 0)], field[hook(18, 3)], field[hook(18, 0)]);
	vertlist[hook(20, (32 * 4) + tid)] = vertexInterp(isoValue, v[hook(19, 4)], v[hook(19, 5)], field[hook(18, 4)], field[hook(18, 5)]);
    vertlist[hook(20, (32 * 5) + tid)] = vertexInterp(isoValue, v[hook(19, 5)], v[hook(19, 6)], field[hook(18, 5)], field[hook(18, 6)]);
    vertlist[hook(20, (32 * 6) + tid)] = vertexInterp(isoValue, v[hook(19, 6)], v[hook(19, 7)], field[hook(18, 6)], field[hook(18, 7)]);
    vertlist[hook(20, (32 * 7) + tid)] = vertexInterp(isoValue, v[hook(19, 7)], v[hook(19, 4)], field[hook(18, 7)], field[hook(18, 4)]);
	vertlist[hook(20, (32 * 8) + tid)] = vertexInterp(isoValue, v[hook(19, 0)], v[hook(19, 4)], field[hook(18, 0)], field[hook(18, 4)]);
    vertlist[hook(20, (32 * 9) + tid)] = vertexInterp(isoValue, v[hook(19, 1)], v[hook(19, 5)], field[hook(18, 1)], field[hook(18, 5)]);
    vertlist[hook(20, (32 * 10) + tid)] = vertexInterp(isoValue, v[hook(19, 2)], v[hook(19, 6)], field[hook(18, 2)], field[hook(18, 6)]);
    vertlist[hook(20, (32 * 11) + tid)] = vertexInterp(isoValue, v[hook(19, 3)], v[hook(19, 7)], field[hook(18, 3)], field[hook(18, 7)]);
    barrier(CLK_LOCAL_MEM_FENCE);

    // output triangle vertices
    uint numVerts = read_imageui(numVertsTex, tableSampler, (int2)(cubeindex,0)).x;

    for(int i=0; i<numVerts; i+=3) {
        uint index = numVertsScanned[hook(3, voxel)] + i;

        float4 v[3];
        uint edge;
        edge = read_imageui(triTex, tableSampler, (int2)(i,cubeindex)).x;
        v[hook(19, 0)] = vertlist[hook(20, (edge * 32) + tid)];

        edge = read_imageui(triTex, tableSampler, (int2)(i+1,cubeindex)).x;
        v[hook(19, 1)] = vertlist[hook(20, (edge * 32) + tid)];

        edge = read_imageui(triTex, tableSampler, (int2)(i+2,cubeindex)).x;
        v[hook(19, 2)] = vertlist[hook(20, (edge * 32) + tid)];

        // calculate triangle surface normal
        float4 n = calcNormal(v[hook(19, 0)], v[hook(19, 1)], v[hook(19, 2)]);

        if (index < (maxVerts - 3)) {
            pos[hook(0, index)] = v[hook(19, 0)];
            norm[hook(1, index)] = n;

            pos[hook(0, index + 1)] = v[hook(19, 1)];
            norm[hook(1, index + 1)] = n;

            pos[hook(0, index + 2)] = v[hook(19, 2)];
            norm[hook(1, index + 2)] = n;
        }
    }
}

