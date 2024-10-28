//{"in":1,"n_pairs":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce2(global float* restrict out, global const float2* restrict in, int n_pairs) {
  int i = get_global_id(0);
  if (i >= n_pairs)
    return;
  float2 v = in[hook(1, i)];
  out[hook(0, i)] = v.x + v.y;
}