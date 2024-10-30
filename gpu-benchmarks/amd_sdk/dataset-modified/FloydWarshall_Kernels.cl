#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}



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
    int oldWeight = pathDistanceBuffer[hook(0, yValue * numNodes + xValue)];
    int tempWeight = (pathDistanceBuffer[hook(0, yValue * numNodes + k)] + pathDistanceBuffer[hook(0, k * numNodes + xValue)]);
    
    if (tempWeight < oldWeight)
    {
        pathDistanceBuffer[hook(0, yValue * numNodes + xValue)] = tempWeight;
        pathBuffer[hook(1, yValue * numNodes + xValue)] = k;
    }
}

