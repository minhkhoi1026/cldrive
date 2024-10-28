//{"Nq":3,"background":5,"length":6,"qx":0,"qy":1,"result":2,"scale":4}
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
kernel void dab_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq, const float scale, const float background, const float length) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];
    result[hook(2, i)] = scale * Iqxy(qxi, qyi, length) + background;
  }
}