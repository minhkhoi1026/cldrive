//{"Nq":3,"background":5,"coeff":9,"cutoff_length":8,"mass_dim":7,"qx":0,"qy":1,"radius":6,"result":2,"scale":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float sph_j1c(float q);
float sph_j1c(float q) {
  const float q2 = q * q;
  float sin_q, cos_q;

  do {
    const float _t_ = q;
    sin_q = sin(_t_);
    cos_q = cos(_t_);
  } while (0);

  const float bessel = (q < 0.384038453352533f) ? (1.0f + q2 * (-3.f / 30.f + q2 * (3.f / 840.f))) : 3.0f * (sin_q / q - cos_q) / q2;

  return bessel;
}

float lanczos_gamma(float q);
float lanczos_gamma(float q) {
  float x, y, tmp, ser;
  float coeff[6] = {76.18009172947146f, -86.50532032941677f, 24.01409824083091f, -1.231739572450155f, 0.1208650973866179e-2f, -0.5395239384953e-5f};

  y = x = q;
  tmp = x + 5.5f;
  tmp -= (x + 0.5f) * log(tmp);
  ser = 1.000000000190015f;
  for (int j = 0; j <= 5; j++) {
    y += 1.0f;
    ser += coeff[hook(9, j)] / y;
  }
  return -tmp + log(2.5066282746310005f * ser / x);
}

float form_volume(float radius);

float Iq(float q, float radius, float mass_dim, float cutoff_length);

float Iqxy(float qx, float qy, float radius, float mass_dim, float cutoff_length);

float _mass_fractal_kernel(float q, float radius, float mass_dim, float cutoff_length) {
  if (mass_dim <= 1.0f) {
    return 0.0f;
  }

  float pq = sph_j1c(q * radius);
  pq = pq * pq;

  float mmo = mass_dim - 1.0f;
  float sq = exp(lanczos_gamma(mmo)) * sin((mmo)*atan(q * cutoff_length));
  sq *= pow(cutoff_length, mmo);
  sq /= pow((1.0f + (q * cutoff_length) * (q * cutoff_length)), (mmo / 2.0f));
  sq /= q;

  float result = pq * sq;

  return result;
}
float form_volume(float radius) {
  return 1.333333333333333f * 3.14159265358979323846f * radius * radius * radius;
}

float Iq(float q, float radius, float mass_dim, float cutoff_length) {
  return _mass_fractal_kernel(q, radius, mass_dim, cutoff_length);
}

float Iqxy(float qx, float qy, float radius, float mass_dim, float cutoff_length) {
  float q = sqrt(qx * qx + qy * qy);
  return _mass_fractal_kernel(q, radius, mass_dim, cutoff_length);
}
kernel void mass_fractal_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq, const float scale, const float background, const float radius, const float mass_dim, const float cutoff_length) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];
    result[hook(2, i)] = scale * Iqxy(qxi, qyi, radius, mass_dim, cutoff_length) + background;
  }
}