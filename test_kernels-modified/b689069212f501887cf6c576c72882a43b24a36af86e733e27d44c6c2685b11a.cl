//{"Fq":7,"n_bodies":3,"n_factors":5,"n_q":1,"t_factors":4,"t_margin_Iq":6,"v_bodies":2,"v_q":0}
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

kernel void margins(const global float* v_q, int n_q, const global float4* v_bodies, int n_bodies, const global float* t_factors, int n_factors,

                    global float* t_margin_Iq) {
  int idx = get_global_id(0);

  int fx_index = __builtin_astype((v_bodies[hook(2, idx)].w), int);

  for (int k = 0; k < n_q; k++) {
    float q = v_q[hook(0, k)];
    const global float* Fq = t_factors + mul24(k, n_factors);
    float Fqx = Fq[hook(7, fx_index)];

    float inner_sum = 0;
    for (int y = 0; y < n_bodies; y++) {
      float qr = q * distance(v_bodies[hook(2, idx)], v_bodies[hook(2, y)]);
      float v1 = native_divide(native_sin(qr), qr);
      v1 = isnan(v1) ? 1 : v1;

      int fy_index = __builtin_astype((v_bodies[hook(2, y)].w), int);

      inner_sum = fma(Fq[hook(7, fy_index)], v1, inner_sum);
    }
    t_margin_Iq[hook(6, idx + k * n_bodies)] = inner_sum * Fqx;
  }
}