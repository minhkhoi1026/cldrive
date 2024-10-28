//{"C":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__kernel void
simpleIncrement( __global float* C)
{
	C[hook(0, get_global_id(0))] += 1.0f;
}