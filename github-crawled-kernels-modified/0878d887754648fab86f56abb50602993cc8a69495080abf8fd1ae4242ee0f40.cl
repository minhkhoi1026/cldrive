//{"Nq":2,"background":4,"q":0,"q0":5,"result":1,"scale":3,"sigma":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(void);
float form_volume(void) {
  return 1.0f;
}

float Iq(float q, float q0, float sigma);
float Iq(float q, float q0, float sigma) {
  float scaled_dq = (q - q0) / sigma;
  return exp(-0.5f * scaled_dq * scaled_dq);
}

float Iqxy(float qx, float qy, float q0, float sigma);
float Iqxy(float qx, float qy, float q0, float sigma) {
  return Iq(sqrt(qx * qx + qy * qy), q0, sigma);
}
kernel void gaussian_peak_Iq(global const float* q, global float* result, const int Nq, const float scale, const float background, const float q0, const float sigma) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];
    result[hook(1, i)] = scale * Iq(qi, q0, sigma) + background;
  }
}