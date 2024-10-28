//{"n_bodies":3,"n_q":1,"t_margin_Iq":4,"v_bodies_f":2,"v_q":0}
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

kernel void margins_mapped_factors(const global float* v_q, int n_q, global float4* v_bodies_f, int n_bodies, global float* t_margin_Iq) {
  int idx = get_global_id(0);

  for (int k = 0; k < n_q; k++) {
    float q = v_q[hook(0, k)];
    float4 bodyx = v_bodies_f[hook(2, k * n_bodies + idx)];
    float Fqx = bodyx.w;
    bodyx.w = 0;

    float inner_sum = 0;
    for (int y = 0; y < n_bodies; y++) {
      float4 bodyy = v_bodies_f[hook(2, k * n_bodies + y)];
      float Fqy = bodyy.w;
      bodyy.w = 0;
      float qr = q * distance(bodyx, bodyy);
      float v1 = native_divide(native_sin(qr), qr);
      v1 = isnan(v1) ? 1 : v1;

      inner_sum += Fqy * v1;
    }
    t_margin_Iq[hook(4, k * n_bodies + idx)] = inner_sum * Fqx;
  }
}