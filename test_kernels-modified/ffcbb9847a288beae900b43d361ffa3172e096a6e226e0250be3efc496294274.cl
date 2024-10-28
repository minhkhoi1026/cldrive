//{"A":0,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Initialise(global float4* A, const float x) {
  int pos = get_global_id(0);
  A[hook(0, pos)] = x;
}