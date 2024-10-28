//{"Nq":2,"background":4,"cor_length":5,"q":0,"result":1,"scale":3}
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
kernel void lorentz_Iq(global const float* q, global float* result, const int Nq, const float scale, const float background, const float cor_length) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];
    result[hook(1, i)] = scale * Iq(qi, cor_length) + background;
  }
}