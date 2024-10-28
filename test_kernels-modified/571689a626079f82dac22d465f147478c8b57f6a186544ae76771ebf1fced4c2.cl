//{"in":0,"n":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pown_(global float4* in, global float4* out, int n) {
  int gX = get_global_id(0);

  out[hook(1, gX)] = pown(in[hook(0, gX)], n);
}