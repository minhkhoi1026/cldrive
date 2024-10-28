//{"n_bodies":3,"n_q":1,"t_bodies_f":4,"t_margin_Iq":5,"v_bodies":2,"v_q":0}
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

kernel void margins_mapped_factors1(const global float* v_q, int n_q, const global float4* v_bodies, int n_bodies, const global float* t_bodies_f, global float* t_margin_Iq) {
  int idx = get_global_id(0);

  for (int k = 0; k < n_q; k++) {
    float q = v_q[hook(0, k)];
    float4 bodyx = v_bodies[hook(2, idx)];

    float inner_sum = 0.0f;
    for (int y = 0; y < n_bodies; y++) {
      float v1 = sinc_qr(q, bodyx, v_bodies[hook(2, y)]);

      inner_sum = fma(t_bodies_f[hook(4, k * n_bodies + y)], v1, inner_sum);
    }
    t_margin_Iq[hook(5, mad24(k, n_bodies, idx))] = inner_sum * t_bodies_f[hook(4, mad24(k, n_bodies, idx))];
  }
}