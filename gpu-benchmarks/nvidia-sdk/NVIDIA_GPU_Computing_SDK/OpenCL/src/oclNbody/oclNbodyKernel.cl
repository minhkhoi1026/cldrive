

#ifdef cl_khr_fp64
    #pragma OPENCL EXTENSION cl_khr_fp64 : enable
#endif

#ifdef cl_amd_fp64
    #pragma OPENCL EXTENSION cl_amd_fp64 : enable
#endif

#define BLOCKDIM 256
#define LOOP_UNROLL 4


#define SX(i) sharedPos[i + mul24(get_local_size(0), get_local_id(1))]


#define SX_SUM(i,j) sharedPos[i + mul24((uint)get_local_size(0), (uint)j)]    

REAL3 bodyBodyInteraction(REAL3 ai, REAL4 bi, REAL4 bj, REAL softeningSquared) 
{
    REAL3 r;

    
    r.x = bi.x - bj.x;
    r.y = bi.y - bj.y;
    r.z = bi.z - bj.z;
    

    
    REAL distSqr = r.x * r.x + r.y * r.y + r.z * r.z;
    distSqr += softeningSquared;

    
    REAL invDist = rsqrt((float)distSqr);
	REAL invDistCube =  invDist * invDist * invDist;

    
    REAL s = bj.w * invDistCube;

    
    ai.x += r.x * s;
    ai.y += r.y * s;
    ai.z += r.z * s;

    return ai;
}


REAL3 gravitation(REAL4 myPos, REAL3 accel, REAL softeningSquared, __local REAL4* sharedPos)
{
    
    
    
    
    
#ifdef _Win64
    unsigned long long i = 0;
#else
    unsigned long i = 0;
#endif

    

    
    
    
    
    
    int blockDimx = get_local_size(0);
    for (unsigned int counter = 0; counter < blockDimx; ) 
    {
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
	counter++;
#if LOOP_UNROLL > 1
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
	counter++;
#endif
#if LOOP_UNROLL > 2
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
	counter += 2;
#endif
#if LOOP_UNROLL > 4
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
        accel = bodyBodyInteraction(accel, SX(i++), myPos, softeningSquared); 
	counter += 4;
#endif
    }

    return accel;
}





#define WRAP(x,m) (((x)<m)?(x):(x-m))  

REAL3 computeBodyAccel_MT(REAL4 bodyPos, 
                           __global REAL4* positions, 
                           int numBodies, 
                           REAL softeningSquared, 
                           __local REAL4* sharedPos)
{

    REAL3 acc = ZERO3;
    
    unsigned int threadIdxx = get_local_id(0);
    unsigned int threadIdxy = get_local_id(1);
    unsigned int blockIdxx = get_group_id(0);
    unsigned int blockIdxy = get_group_id(1);
    unsigned int gridDimx = get_num_groups(0);
    unsigned int blockDimx = get_local_size(0);
    unsigned int blockDimy = get_local_size(1);
    unsigned int numTiles = numBodies / mul24(blockDimx, blockDimy);

    for (unsigned int tile = blockIdxy; tile < numTiles + blockIdxy; tile++) 
    {
        sharedPos[threadIdxx + blockDimx * threadIdxy] = 
            positions[WRAP(blockIdxx + mul24(blockDimy, tile) + threadIdxy, gridDimx) * blockDimx
                      + threadIdxx];
       
        
        barrier(CLK_LOCAL_MEM_FENCE);

        
        acc = gravitation(bodyPos, acc, softeningSquared, sharedPos);
        
        
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    
    
    
    
    
    
    
    

    
    
        SX_SUM(threadIdxx, threadIdxy).x = acc.x;
        SX_SUM(threadIdxx, threadIdxy).y = acc.y;
        SX_SUM(threadIdxx, threadIdxy).z = acc.z;

        barrier(CLK_LOCAL_MEM_FENCE);

        
        if (get_local_id(0) == 0) 
        {
            for (unsigned int i = 1; i < blockDimy; i++) 
            {
                acc.x += SX_SUM(threadIdxx, i).x;
                acc.y += SX_SUM(threadIdxx, i).y;
                acc.z += SX_SUM(threadIdxx, i).z;
            }
        }

    return acc;
}

REAL3 computeBodyAccel_noMT(REAL4 bodyPos, 
                             __global REAL4* positions, 
                             int numBodies, 
                             REAL softeningSquared, 
                             __local REAL4* sharedPos)
{
    REAL3 acc = ZERO3;
    
    unsigned int threadIdxx = get_local_id(0);
    unsigned int threadIdxy = get_local_id(1);
    unsigned int blockIdxx = get_group_id(0);
    unsigned int blockIdxy = get_group_id(1);
    unsigned int gridDimx = get_num_groups(0);
    unsigned int blockDimx = get_local_size(0);
    unsigned int blockDimy = get_local_size(1);
    unsigned int numTiles = numBodies / mul24(blockDimx, blockDimy);

    for (unsigned int tile = blockIdxy; tile < numTiles + blockIdxy; tile++) 
    {
        sharedPos[threadIdxx + mul24(blockDimx, threadIdxy)] = 
            positions[WRAP(blockIdxx + tile, gridDimx) * blockDimx + threadIdxx];
       
        barrier(CLK_LOCAL_MEM_FENCE);

        
        acc = gravitation(bodyPos, acc, softeningSquared, sharedPos);
        
        barrier(CLK_LOCAL_MEM_FENCE);
    }

    
    
    
    
    
    
    
    
    

    
    

    return acc;
}

__kernel void integrateBodies_MT(
            __global REAL4* newPos,
            __global REAL4* newVel, 
            __global REAL4* oldPos,
            __global REAL4* oldVel,
            REAL deltaTime,
            REAL damping,
            REAL softeningSquared,
            int numBodies,
            __local REAL4* sharedPos)
{
    unsigned int threadIdxx = get_local_id(0);
    unsigned int threadIdxy = get_local_id(1);
    unsigned int blockIdxx = get_group_id(0);
    unsigned int blockIdxy = get_group_id(1);
    unsigned int gridDimx = get_num_groups(0);
    unsigned int blockDimx = get_local_size(0);
    unsigned int blockDimy = get_local_size(1);

    unsigned int index = mul24(blockIdxx, blockDimx) + threadIdxx;
    REAL4 pos = oldPos[index];   
    REAL3 accel = computeBodyAccel_MT(pos, oldPos, numBodies, softeningSquared, sharedPos);

    
    
    
    
    REAL4 vel = oldVel[index];
       
    vel.x += accel.x * deltaTime;
    vel.y += accel.y * deltaTime;
    vel.z += accel.z * deltaTime;  

    vel.x *= damping;
    vel.y *= damping;
    vel.z *= damping;
        
    
    pos.x += vel.x * deltaTime;
    pos.y += vel.y * deltaTime;
    pos.z += vel.z * deltaTime;

    
    newPos[index] = pos;
    newVel[index] = vel;
}

__kernel void integrateBodies_noMT(
            __global REAL4* newPos,
            __global REAL4* newVel, 
            __global REAL4* oldPos,
            __global REAL4* oldVel,
            REAL deltaTime,
            REAL damping,
            REAL softeningSquared,
            int numBodies,
            __local REAL4* sharedPos)
{
    unsigned int threadIdxx = get_local_id(0);
    unsigned int threadIdxy = get_local_id(1);
    unsigned int blockIdxx = get_group_id(0);
    unsigned int blockIdxy = get_group_id(1);
    unsigned int gridDimx = get_num_groups(0);
    unsigned int blockDimx = get_local_size(0);
    unsigned int blockDimy = get_local_size(1);

    unsigned int index = mul24(blockIdxx, blockDimx) + threadIdxx;
    REAL4 pos = oldPos[index];   
    REAL3 accel = computeBodyAccel_noMT(pos, oldPos, numBodies, softeningSquared, sharedPos);

    
    
    
    
    REAL4 vel = oldVel[index];
       
    vel.x += accel.x * deltaTime;
    vel.y += accel.y * deltaTime;
    vel.z += accel.z * deltaTime;  

    vel.x *= damping;
    vel.y *= damping;
    vel.z *= damping;
        
    
    pos.x += vel.x * deltaTime;
    pos.y += vel.y * deltaTime;
    pos.z += vel.z * deltaTime;

    
    newPos[index] = pos;
    newVel[index] = vel;
}

