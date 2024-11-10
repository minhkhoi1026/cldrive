






#define UMAD(a, b, c)  ( (a) * (b) + (c) )

typedef struct{
    float x;
    float y;
    float z;
} Float3;

typedef struct{
    uint x;
    uint y;
    uint z;
}Uint3;

typedef struct{
    int x;
    int y;
    int z;
}Int3;


typedef struct{
    Float3 colliderPos;
    float  colliderRadius;

    Float3 gravity;
    float globalDamping;
    float particleRadius;

    Uint3 gridSize;
    uint numCells;
    Float3 worldOrigin;
    Float3 cellSize;

    uint numBodies;
    uint maxParticlesPerCell;

    float spring;
    float damping;
    float shear;
    float attraction;
    float boundaryDamping;
} simParams_t;






__kernel void integrate(
    __global float4 *d_Pos,  
    __global float4 *d_Vel,  
    __constant simParams_t *params,
    float deltaTime,
    uint numParticles
){
    const uint index = get_global_id(0);
    if(index >= numParticles)
        return;

    float4 pos = d_Pos[index];
    float4 vel = d_Vel[index];

    pos.w = 1.0f;
    vel.w = 0.0f;

    
    vel += (float4)(params->gravity.x, params->gravity.y, params->gravity.z, 0) * deltaTime;
    vel *= params->globalDamping;

    
    pos += vel * deltaTime;


    
    if(pos.x < -1.0f + params->particleRadius){
        pos.x = -1.0f + params->particleRadius;
        vel.x *= params->boundaryDamping;
    }
    if(pos.x > 1.0f - params->particleRadius){
        pos.x = 1.0f - params->particleRadius;
        vel.x *= params->boundaryDamping;
    }

    if(pos.y < -1.0f + params->particleRadius){
        pos.y = -1.0f + params->particleRadius;
        vel.y *= params->boundaryDamping;
    }
    if(pos.y > 1.0f - params->particleRadius){
        pos.y = 1.0f - params->particleRadius;
        vel.y *= params->boundaryDamping;
    }

    if(pos.z < -1.0f + params->particleRadius){
        pos.z = -1.0f + params->particleRadius;
        vel.z *= params->boundaryDamping;
    }
    if(pos.z > 1.0f - params->particleRadius){
        pos.z = 1.0f - params->particleRadius;
        vel.z *= params->boundaryDamping;
    }

    
    d_Pos[index] = pos;
    d_Vel[index] = vel;
}







int4 getGridPos(float4 p, __constant simParams_t *params){
    int4 gridPos;
    gridPos.x = (int)floor((p.x - params->worldOrigin.x) / params->cellSize.x);
    gridPos.y = (int)floor((p.y - params->worldOrigin.y) / params->cellSize.y);
    gridPos.z = (int)floor((p.z - params->worldOrigin.z) / params->cellSize.z);
    gridPos.w = 0;
    return gridPos;
}


uint getGridHash(int4 gridPos, __constant simParams_t *params){
    
    gridPos.x = gridPos.x & (params->gridSize.x - 1);
    gridPos.y = gridPos.y & (params->gridSize.y - 1);
    gridPos.z = gridPos.z & (params->gridSize.z - 1);
    return UMAD( UMAD(gridPos.z, params->gridSize.y, gridPos.y), params->gridSize.x, gridPos.x );
}



__kernel void calcHash(
    __global uint        *d_Hash, 
    __global uint       *d_Index, 
    __global const float4 *d_Pos, 
    __constant simParams_t *params,
    uint numParticles
){
    const uint index = get_global_id(0);
    if(index >= numParticles)
        return;

    float4 p = d_Pos[index];

    
    int4  gridPos = getGridPos(p, params);
    uint gridHash = getGridHash(gridPos, params);

    
    d_Hash[index] = gridHash;
    d_Index[index] = index;
}






__kernel void Memset(
    __global uint *d_Data,
    uint val,
    uint N
){
    if(get_global_id(0) < N)
        d_Data[get_global_id(0)] = val;
}

__kernel void findCellBoundsAndReorder(
    __global uint   *d_CellStart,     
    __global uint   *d_CellEnd,       
    __global float4 *d_ReorderedPos,  
    __global float4 *d_ReorderedVel,  

    __global const uint   *d_Hash,    
    __global const uint   *d_Index,   
    __global const float4 *d_Pos,     
    __global const float4 *d_Vel,     
    __local uint *localHash,          
    uint    numParticles
){
    uint hash;
    const uint index = get_global_id(0);

    
    if(index < numParticles){
        hash = d_Hash[index];

        
        
        
        localHash[get_local_id(0) + 1] = hash;

        
        if(index > 0 && get_local_id(0) == 0)
            localHash[0] = d_Hash[index - 1];
    }

    barrier(CLK_LOCAL_MEM_FENCE);

    if(index < numParticles){
        
        if(index == 0)
            d_CellStart[hash] = 0;

        
        else{
            if(hash != localHash[get_local_id(0)])
                d_CellEnd[localHash[get_local_id(0)]]  = d_CellStart[hash] = index;
        };

        
        if(index == numParticles - 1)
            d_CellEnd[hash] = numParticles;


        
        uint sortedIndex = d_Index[index];
        float4 pos = d_Pos[sortedIndex];
        float4 vel = d_Vel[sortedIndex];

        d_ReorderedPos[index] = pos;
        d_ReorderedVel[index] = vel;
    }
}






float4 collideSpheres(
    float4 posA,
    float4 posB,
    float4 velA,
    float4 velB,
    float radiusA,
    float radiusB,
    float spring,
    float damping,
    float shear,
    float attraction
){
    
    float4     relPos = (float4)(posB.x - posA.x, posB.y - posA.y, posB.z - posA.z, 0);
    float        dist = sqrt(relPos.x * relPos.x + relPos.y * relPos.y + relPos.z * relPos.z);
    float collideDist = radiusA + radiusB;

    float4 force = (float4)(0, 0, 0, 0);
    if(dist < collideDist){
        float4 norm = (float4)(relPos.x / dist, relPos.y / dist, relPos.z / dist, 0);

        
        float4 relVel = (float4)(velB.x - velA.x, velB.y - velA.y, velB.z - velA.z, 0);

        
        float relVelDotNorm = relVel.x * norm.x + relVel.y * norm.y + relVel.z * norm.z;
        float4 tanVel = (float4)(relVel.x - relVelDotNorm * norm.x, relVel.y - relVelDotNorm * norm.y, relVel.z - relVelDotNorm * norm.z, 0);

        
        float springFactor = -spring * (collideDist - dist);
        force = (float4)(
            springFactor * norm.x + damping * relVel.x + shear * tanVel.x + attraction * relPos.x,
            springFactor * norm.y + damping * relVel.y + shear * tanVel.y + attraction * relPos.y,
            springFactor * norm.z + damping * relVel.z + shear * tanVel.z + attraction * relPos.z,
            0
        );
    }

    return force;
}



__kernel void collide(
    __global float4       *d_Vel,          
    __global const float4 *d_ReorderedPos, 
    __global const float4 *d_ReorderedVel, 
    __global const uint   *d_Index,        
    __global const uint   *d_CellStart,    
    __global const uint   *d_CellEnd,
    __constant simParams_t *params,
    uint    numParticles
){
    uint index = get_global_id(0);
    if(index >= numParticles)
        return;

    float4   pos = d_ReorderedPos[index];
    float4   vel = d_ReorderedVel[index];
    float4 force = (float4)(0, 0, 0, 0);

    
    int4 gridPos = getGridPos(pos, params);

    
    for(int z = -1; z <= 1; z++)
        for(int y = -1; y <= 1; y++)
            for(int x = -1; x <= 1; x++){
                
                uint   hash = getGridHash(gridPos + (int4)(x, y, z, 0), params);
                uint startI = d_CellStart[hash];

                
                if(startI == 0xFFFFFFFFU)
                    continue;

                
                uint endI = d_CellEnd[hash];
                for(uint j = startI; j < endI; j++){
                    if(j == index)
                        continue;

                    float4 pos2 = d_ReorderedPos[j];
                    float4 vel2 = d_ReorderedVel[j];

                    
                    force += collideSpheres(
                        pos, pos2,
                        vel, vel2,
                        params->particleRadius, params->particleRadius, 
                        params->spring, params->damping, params->shear, params->attraction
                    );
                }
            }

    
    force += collideSpheres(
        pos, (float4)(params->colliderPos.x, params->colliderPos.y, params->colliderPos.z, 0),
        vel, (float4)(0, 0, 0, 0),
        params->particleRadius, params->colliderRadius,
        params->spring, params->damping, params->shear, params->attraction
    );

    
    d_Vel[d_Index[index]] = vel + force;
}