//{"Nq":2,"arms":6,"background":4,"q":0,"radius2":5,"result":1,"scale":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(void);
float Iq(float q, float radius2, float arms);
float Iqxy(float qx, float qy, float radius2, float arms);
float _mass_fractal_kernel(float q, float radius2, float arms) {
  float u_2 = radius2 * pow(q, 2);
  float v = u_2 * arms / (3.0f * arms - 2.0f);

  float term1 = v - 1.0f + exp(-v);
  float term2 = ((arms - 1.0f) / 2.0f) * pow((1.0f - exp(-v)), 2.0f);

  return (2.0f * (term1 + term2)) / (arms * pow(v, 2.0f));
}

float form_volume(void) {
  return 1.0f;
}

float Iq(float q, float radius2, float arms) {
  return _mass_fractal_kernel(q, radius2, arms);
}

float Iqxy(float qx, float qy, float radius2, float arms) {
  float q = sqrt(qx * qx + qy * qy);
  return _mass_fractal_kernel(q, radius2, arms);
}
kernel void star_polymer_Iq(global const float* q, global float* result, const int Nq, const float scale, const float background, const float radius2, const float arms) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];
    result[hook(1, i)] = scale * Iq(qi, radius2, arms) + background;
  }
}