//{"n_bodies":1,"out_v_Iq":2,"t_margin_Iq":0}
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

kernel void sum(global float* t_margin_Iq, int n_bodies, global float* out_v_Iq) {
  int idx = get_global_id(0);

  float Iq = 0;
  for (int i = 0; i < n_bodies; i++) {
    Iq += t_margin_Iq[hook(0, ((idx) * (n_bodies) + (i)))];
  }
  out_v_Iq[hook(2, idx)] = Iq;
}