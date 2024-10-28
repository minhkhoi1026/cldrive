//{"Nq":3,"background":5,"qx":0,"qy":1,"result":2,"rg":6,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Iq(float q, float rg);
float Iq(float q, float rg) {
  float exponent = rg * rg * q * q / 3.0f;
  float value = exp(-exponent);
  return value;
}

float Iqxy(float qx, float qy, float rg);
float Iqxy(float qx, float qy, float rg) {
  return Iq(sqrt(qx * qx + qy * qy), rg);
}
kernel void guinier_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq, const float scale, const float background, const float rg) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];
    result[hook(2, i)] = scale * Iqxy(qxi, qyi, rg) + background;
  }
}