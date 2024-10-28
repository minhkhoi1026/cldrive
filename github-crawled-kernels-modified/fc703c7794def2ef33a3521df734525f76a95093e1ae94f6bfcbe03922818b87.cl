//{"map":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normal_map(global float* map) {
  size_t x = get_global_id(0);
  size_t width = get_global_size(0);
  size_t y = get_global_id(1);
  size_t idx = (y * width) + x;
  idx *= 2U;

  float3 n;

  if (x >= width - 1U || y >= get_global_size(1) - 1U) {
    n = __builtin_astype((2147483647), float);

  } else {
    float3 V_k_u_v = vload3(idx, map);
    float3 V_k_u1_v = vload3(idx + 2U, map);
    float3 V_k_u_v1 = vload3(idx + (width * 2U), map);

    float3 u = V_k_u1_v - V_k_u_v;
    float3 v = V_k_u_v1 - V_k_u_v;

    float3 x_vec;

    x_vec.x = u.y * v.z - u.z * v.y;
    x_vec.y = u.z * v.x - u.x * v.z;
    x_vec.z = u.x * v.y - u.y * v.x;

    float l2_norm_x = sqrt(dot(x_vec, x_vec));

    n = x_vec / l2_norm_x;
  }

  vstore3(n, idx + 1U, map);
}