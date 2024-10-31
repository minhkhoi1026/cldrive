
 
 #ifndef PARTICLESYSTEM_COMMON_H
#define PARTICLESYSTEM_COMMON_H

#include <GL/glew.h>

#include <oclUtils.h>
#include "vector_types.h"




typedef unsigned int uint;
typedef cl_mem memHandle_t;


typedef struct{
    float3 colliderPos;
    float  colliderRadius;

    float3 gravity;
    float globalDamping;
    float particleRadius;

    uint3 gridSize;
    uint numCells;
    float3 worldOrigin;
    float3 cellSize;

    uint numBodies;
    uint maxParticlesPerCell;

    float spring;
    float damping;
    float shear;
    float attraction;
    float boundaryDamping;
} simParams_t;




extern "C" void startupOpenCL(int argc, const char **argv);
extern "C" void shutdownOpenCL(void);

extern "C" void allocateArray(memHandle_t *memObj, size_t size);
extern "C" void freeArray(memHandle_t memObj);

extern "C" void copyArrayFromDevice(void *hostPtr, const memHandle_t memObj, unsigned int vbo, size_t size);
extern "C" void copyArrayToDevice(memHandle_t memObj, const void *hostPtr, size_t offset, size_t size);

extern "C" void registerGLBufferObject(unsigned int vbo);
extern "C" void unregisterGLBufferObject(unsigned int vbo);

extern "C" memHandle_t mapGLBufferObject(uint vbo);
extern "C" void unmapGLBufferObject(uint vbo);

#endif
