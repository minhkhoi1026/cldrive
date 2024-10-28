#include "macros.hpp"
























__kernel 
void globalAtomics(
		volatile __global uint *input,
		uint value,
		__global uint* counter)                         
{                                                                         
	size_t globalId = get_global_id(0);
	
	if(value == input[globalId])
		atomic_inc(&counter[0]);
}                                                                         

