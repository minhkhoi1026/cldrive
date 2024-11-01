

void atomicAddGlobal(volatile __global float *ptr, float value)
{
    unsigned int oldIntVal, newIntVal;
    float newFltVal;

    do
    {
        oldIntVal = *((volatile __global unsigned int *)ptr);
        newFltVal = ((*(float*)(&oldIntVal)) + value);
        newIntVal = *((unsigned int *)(&newFltVal));
    }
    while (atomic_cmpxchg((volatile __global unsigned int *)ptr, oldIntVal, newIntVal) != oldIntVal);
}

void atomicAddLocal(volatile __local float *ptr, float value)
{
    unsigned int oldIntVal, newIntVal;
    float newFltVal;

    do
    {
        oldIntVal = *((volatile __local unsigned int *)ptr);
        newFltVal = ((*(float*)(&oldIntVal)) + value);
        newIntVal = *((unsigned int *)(&newFltVal));
    }
    while (atomic_cmpxchg((volatile __local unsigned int *)ptr, oldIntVal, newIntVal) != oldIntVal);
}

__kernel
void assignCentroid(
    __global float2 *pointPos,
    __global uint *KMeansCluster,
    __global float2 *centroidPos,
    __global float2 *globalClusterBin,          
    __global unsigned int *globalClusterCount,
    __local float2 *localClusterBin,            
    __local unsigned int *localClusterCount,
    uint k, uint numPoints)
{
    unsigned int gid = get_global_id(0);
    unsigned int lid = get_local_id(0);
    __local float* localBinPtr = (__local float*)localClusterBin;
    
    if(lid < k)
    {
        localClusterBin[lid] = (float2)0.0;
        localClusterCount[lid] = 0;
    }
    barrier(CLK_LOCAL_MEM_FENCE);
    
    
    float2 vPoint = pointPos[gid];
    float leastDist = FLT_MAX;
    uint closestCentroid = 0;
    
    for(int i=0; i<k; i++)
    {
        
        #ifdef USE_POWN
        float dist = pown((vPoint.even - centroidPos[i].even), 2) + 
                          pown((vPoint.odd - centroidPos[i].odd), 2);
        #else
        float xDist = (vPoint.x - centroidPos[i].x);
        float yDist = (vPoint.y - centroidPos[i].y);
        float dist = (xDist * xDist) + (yDist * yDist);
        #endif
        leastDist = fmin( leastDist, dist );

        closestCentroid = (leastDist == dist) ? i : closestCentroid;
    }
    
    KMeansCluster[gid] = closestCentroid;

    atomicAddLocal( &localBinPtr[2 * closestCentroid], vPoint.x );
    atomicAddLocal( &localBinPtr[2 * closestCentroid + 1], vPoint.y );
    atomic_inc( &localClusterCount[closestCentroid] );
    barrier(CLK_LOCAL_MEM_FENCE);

    
    if(lid < k)
    {
        atomicAddGlobal( ((__global float*)(globalClusterBin) + (2 * lid)), localClusterBin[lid].x );
        atomicAddGlobal( ((__global float*)(globalClusterBin) + (2 * lid) + 1), localClusterBin[lid].y );
        atomic_add( &globalClusterCount[lid], localClusterCount[lid] );
    }
}


__kernel void computeSilhouettes(__global float2* pointPos,
                                __global float2* centroidPos, 
                                __global unsigned int* KmeansCluster, 
                                __global unsigned int* globalClusterCount, 
                                __local int* lClusterCount, 
                                int k, 
                                int numPoints, 
                                __local float* lSilhouetteValue, 
                                __global float* gSilhoutteValue)
{
    int gid = get_global_id(0);
    int lid = get_local_id(0);
    if(lid == 0)
    {
        lSilhouetteValue[0] = 0.f;
    }
    if(lid < k)
    {
        lClusterCount[lid] = globalClusterCount[lid];
    }
    barrier(CLK_LOCAL_MEM_FENCE);

    float silhScore = 0.f;
    float dissimilarities[MAX_CLUSTERS] = {0.0f};
    
    for(int i=0; i<numPoints; i++)
    {
        dissimilarities[KmeansCluster[i]] += (sqrt(pow(pointPos[i].s0 - pointPos[gid].s0, 2.0f)
                                             + pow(pointPos[i].s1 - pointPos[gid].s1, 2.0f)));
    }
    
    float a = dissimilarities[KmeansCluster[gid]] / lClusterCount[KmeansCluster[gid]];
    float b = FLT_MAX;
    for(int i=0; i<k; i++)
    {
        if(i != KmeansCluster[gid])
            b =  min(b, dissimilarities[i] / lClusterCount[i]);
    }
    
    silhScore = ((b - a) / max(a, b));
    
    atomicAddLocal(lSilhouetteValue, silhScore);
    barrier(CLK_LOCAL_MEM_FENCE);
    
    if(lid == 0)
    {
        atomicAddGlobal(gSilhoutteValue, lSilhouetteValue[0]);
    }
}
