//{"in":1,"n_quarts":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reduce4_sat(global int* restrict out, global const int4* restrict in, int n_quarts) {
  const int gws_ = get_global_size(0);
  int i = get_global_id(0);
  int acc = 0.0f;
  while (i < n_quarts) {
    int4 v = in[hook(1, i)];
    acc += out[hook(0, i)] = (v.x + v.y) + (v.z + v.w);
    i += gws_;
  }
  out[hook(0, get_global_id(0))] = acc;
}