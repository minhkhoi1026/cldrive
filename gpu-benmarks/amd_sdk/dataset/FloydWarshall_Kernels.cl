#include "macros.hpp"



inline 
unsigned int uintMin(unsigned int a, unsigned int b)
{
    return (b < a) ? b : a;
}



__kernel 
void floydWarshallPass(__global uint * pathDistanceBuffer, 
                       __global uint * pathBuffer        , 
                       const unsigned int numNodes                  , 
                       const unsigned int pass                   )
{
    int xValue = get_global_id(0);
    int yValue = get_global_id(1);

    int k = pass;
    int oldWeight = pathDistanceBuffer[yValue * numNodes + xValue];
    int tempWeight = (pathDistanceBuffer[yValue * numNodes + k] + pathDistanceBuffer[k * numNodes + xValue]);
    
    if (tempWeight < oldWeight)
    {
        pathDistanceBuffer[yValue * numNodes + xValue] = tempWeight;
        pathBuffer[yValue * numNodes + xValue] = k;
    }
}

