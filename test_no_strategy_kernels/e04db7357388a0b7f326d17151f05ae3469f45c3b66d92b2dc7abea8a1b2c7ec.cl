//{"n_bodies":2,"n_factors":4,"n_q":0,"t_bodies_f":5,"t_factors":3,"v_bodies":1,"v_prev_bodies":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void map_factors2(int n_q, global float4* v_bodies, int n_bodies, const global float* t_factors, int n_factors, global float* t_bodies_f, global float4* v_prev_bodies) {
  size_t idx = get_global_id(0);

  float4 body = v_bodies[hook(1, idx)];
  int factor_index = __builtin_astype((body.w), int);
  body.w = 0.0f;
  v_prev_bodies[hook(6, idx)] = body;
  v_bodies[hook(1, idx)].w = 0.0f;

  for (int k = 0; k < n_q; k++) {
    t_bodies_f[hook(5, k * n_bodies + idx)] = t_factors[hook(3, k * n_factors + factor_index)];
  }
}