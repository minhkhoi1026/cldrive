//{"in":1,"n_hex":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce4_sl(global float* restrict out, global const float4* restrict in, int n_hex) {
  int i = get_global_id(0);
  int gws = get_global_size(0);
  if (i >= n_hex)
    return;
  float4 v0 = in[hook(1, i + 0 * gws)];
  float4 v1 = in[hook(1, i + 1 * gws)];
  float4 v2 = in[hook(1, i + 2 * gws)];
  float4 v3 = in[hook(1, i + 3 * gws)];

  float4 v = (v0 + v1) + (v2 + v3);
  out[hook(0, i)] = (v.x + v.y) + (v.z + v.w);
}