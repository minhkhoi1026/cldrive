//{"Nq":2,"background":4,"length":5,"q":0,"result":1,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Iq(float q, float length);
float Iq(float q, float length) {
  float numerator = pow(length, 3);
  float denominator = pow(1 + pow(q * length, 2), 2);

  return numerator / denominator;
}

float Iqxy(float qx, float qy, float length);
float Iqxy(float qx, float qy, float length) {
  return Iq(sqrt(qx * qx + qy * qy), length);
}
kernel void dab_Iq(global const float* q, global float* result, const int Nq, const float scale, const float background, const float length) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];
    result[hook(1, i)] = scale * Iq(qi, length) + background;
  }
}