//{"n_bodies":2,"n_factors":4,"n_q":0,"t_bodies_f":5,"t_factors":3,"v_bodies":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sinc_qr(float q, float4 bodyx, float4 bodyy) {
  float qr = q * distance(bodyx, bodyy);
  float v1 = native_divide(native_sin(qr), qr);
  return isnan(v1) ? 1.0f : v1;
}

kernel void map_factors1(int n_q, global float4* v_bodies, int n_bodies, const global float* t_factors, int n_factors, global float* t_bodies_f) {
  size_t idx = get_global_id(0);

  float4 body = v_bodies[hook(1, idx)];
  int factor_index = __builtin_astype((body.w), int);
  v_bodies[hook(1, idx)].w = 0.0f;

  for (int k = 0; k < n_q; k++) {
    t_bodies_f[hook(5, k * n_bodies + idx)] = t_factors[hook(3, k * n_factors + factor_index)];
  }
}