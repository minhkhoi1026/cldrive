
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}




__kernel 
void bitonicSort(__global uint * theArray,
                 const uint stage, 
                 const uint passOfStage,
                 const uint direction)
{
    uint sortIncreasing = direction;
    uint threadId = get_global_id(0);
    
    uint pairDistance = 1 << (stage - passOfStage);
    uint blockWidth   = 2 * pairDistance;

    uint leftId = (threadId % pairDistance) 
                   + (threadId / pairDistance) * blockWidth;

    uint rightId = leftId + pairDistance;
    
    uint leftElement = theArray[hook(0, leftId)];
    uint rightElement = theArray[hook(0, rightId)];
    
    uint sameDirectionBlockWidth = 1 << stage;
    
    if((threadId/sameDirectionBlockWidth) % 2 == 1)
        sortIncreasing = 1 - sortIncreasing;

    uint greater;
    uint lesser;
    if(leftElement > rightElement)
    {
        greater = leftElement;
        lesser  = rightElement;
    }
    else
    {
        greater = rightElement;
        lesser  = leftElement;
    }
    
    if(sortIncreasing)
    {
        theArray[hook(0, leftId)]  = lesser;
        theArray[hook(0, rightId)] = greater;
    }
    else
    {
        theArray[hook(0, leftId)]  = greater;
        theArray[hook(0, rightId)] = lesser;
    }
}
