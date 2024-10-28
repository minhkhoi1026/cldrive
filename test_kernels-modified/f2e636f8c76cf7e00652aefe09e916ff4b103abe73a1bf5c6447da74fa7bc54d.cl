//{"Nq":2,"background":4,"q":0,"result":1,"rg":5,"scale":3}
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
kernel void guinier_Iq(global const float* q, global float* result, const int Nq, const float scale, const float background, const float rg) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];
    result[hook(1, i)] = scale * Iq(qi, rg) + background;
  }
}