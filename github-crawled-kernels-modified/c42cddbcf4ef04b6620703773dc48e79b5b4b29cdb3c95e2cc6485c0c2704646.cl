//{"K_inv":2,"dest":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vertex_map(const global float* src, global float* dest, const global float* K_inv) {
  size_t x = get_global_id(0);
  size_t width = get_global_size(0);
  size_t y = get_global_id(1);
  size_t idx = (y * width) + x;
  float depth = src[hook(0, idx)];

  float3 v;
  if (isnan(depth) || (depth <= (0.1f))) {
    v = __builtin_astype((2147483647), float);

  } else {
    float v1 = K_inv[hook(2, 0)] * x + K_inv[hook(2, 1)] * y + K_inv[hook(2, 2)];
    float v2 = K_inv[hook(2, 3)] * x + K_inv[hook(2, 4)] * y + K_inv[hook(2, 5)];
    float v3 = K_inv[hook(2, 6)] * x + K_inv[hook(2, 7)] * y + K_inv[hook(2, 8)];

    v = depth * (float3)(v1, v2, v3);
  }

  vstore3(v, idx * 2U, dest);
}