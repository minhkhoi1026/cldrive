//{"in":1,"n_quarts":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce4(global float* restrict out, global const float4* restrict in, int n_quarts) {
  int i = get_global_id(0);
  if (i >= n_quarts)
    return;
  float4 v = in[hook(1, i)];
  out[hook(0, i)] = (v.x + v.y) + (v.z + v.w);
}