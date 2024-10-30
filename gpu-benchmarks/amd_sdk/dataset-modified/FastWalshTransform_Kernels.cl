#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}




__kernel 
void fastWalshTransform(__global float * tArray,
                        __const  int   step 
                       )
{
		unsigned int tid = get_global_id(0);
		
        const unsigned int group = tid%step;
        const unsigned int pair  = 2*step*(tid/step) + group;

        const unsigned int match = pair + step;
        
        float T1          = tArray[hook(0, pair)];
        float T2          = tArray[hook(0, match)];
       
        tArray[hook(0, pair)]             = T1 + T2; 
        tArray[hook(0, match)]            = T1 - T2;
}
