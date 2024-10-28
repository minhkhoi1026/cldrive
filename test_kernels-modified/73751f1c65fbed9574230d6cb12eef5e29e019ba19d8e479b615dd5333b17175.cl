//{"Nq":3,"background":5,"q0":6,"qx":0,"qy":1,"result":2,"scale":4,"sigma":7}
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
kernel void gaussian_peak_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq, const float scale, const float background, const float q0, const float sigma) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];
    result[hook(2, i)] = scale * Iqxy(qxi, qyi, q0, sigma) + background;
  }
}