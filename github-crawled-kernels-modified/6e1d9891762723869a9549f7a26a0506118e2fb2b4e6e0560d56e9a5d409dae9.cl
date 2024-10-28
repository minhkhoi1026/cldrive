//{"cost_vol":0,"d":1,"dims":3,"sqrt_cost_range":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void init_depth(global float* cost_vol, global float* d, global float* sqrt_cost_range, int4 dims) {
  int i = 1;
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int ij = mad24(coord.y, dims.x, coord.x);
  int index = mul24(ij, dims.z);

  float min_v = cost_vol[hook(0, index)];
  float max_v = min_v;
  float min_k = 0;
  for (; i < dims.z; i++) {
    float val = cost_vol[hook(0, index + i)];
    if (val < min_v) {
      min_v = val;
      min_k = i;
    }
    if (val > max_v) {
      max_v = val;
    }
  }

  sqrt_cost_range[hook(2, ij)] = sqrt(max_v - min_v);
  d[hook(1, ij)] = (min_k + 0.5f) / (float)dims.z;
}