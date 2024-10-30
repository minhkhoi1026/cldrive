#include "macros.hpp"

int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}

__kernel void helloworld(__global char* in, __global char* out)
{
	int num = get_global_id(0);
	out[hook(1, num)] = in[hook(0, num)] + 1;
}