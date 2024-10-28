//{"Nq":3,"background":5,"cor_length":6,"qx":0,"qy":1,"result":2,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Iq(float q, float cor_length);
float Iq(float q, float cor_length) {
  float denominator = 1 + (q * cor_length) * (q * cor_length);
  return 1 / denominator;
}

float Iqxy(float qx, float qy, float cor_length);
float Iqxy(float qx, float qy, float cor_length) {
  return Iq(sqrt(qx * qx + qy * qy), cor_length);
}
kernel void lorentz_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq, const float scale, const float background, const float cor_length) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];
    result[hook(2, i)] = scale * Iqxy(qxi, qyi, cor_length) + background;
  }
}