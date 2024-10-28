//{"Nq":3,"background":5,"edge_sep":7,"num_pearls":8,"pearl_sld":9,"qx":0,"qy":1,"radius":6,"result":2,"scale":4,"solvent_sld":10}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(float radius, float num_pearls);
float Iq(float q, float radius, float edge_sep, float num_pearls, float pearl_sld, float solvent_sld);
float Iqxy(float qx, float qy, float radius, float edge_sep, float num_pearls, float pearl_sld, float solvent_sld);
float linear_pearls_kernel(float q, float radius, float edge_sep, float num_pearls, float pearl_sld, float solvent_sld);
float form_volume(float radius, float num_pearls) {
  float pearl_vol = 4.0f / 3.0f * 3.14159265358979323846f * pow(radius, 3.0f);

  return num_pearls * pearl_vol;
  ;
}

float sinc(float x) {
  if (x == 0.0f) {
    return 1.0f;
  }
  return sin(x) / x;
}

float linear_pearls_kernel(float q, float radius, float edge_sep, float num_pearls, float pearl_sld, float solvent_sld) {
  float n_contrib;

  float contrast_pearl = pearl_sld - solvent_sld;

  float pearl_vol = 4.0f / 3.0f * 3.14159265358979323846f * pow(radius, 3.0f);

  float tot_vol = num_pearls * pearl_vol;

  float m_s = contrast_pearl * pearl_vol;

  float separation = edge_sep + 2.0f * radius;

  float x = q * radius;

  float psi = sin(q * radius);
  psi -= x * cos(x);
  psi /= pow((q * radius), 3.0f);

  int n_max = num_pearls - 1;
  n_contrib = num_pearls;
  for (int num = 1; num <= n_max; num++) {
    n_contrib += (2.0f * (num_pearls - num) * sinc(q * separation * num));
  }

  float form_factor = n_contrib;
  form_factor *= pow((m_s * psi * 3.0f), 2.0f);
  form_factor /= (tot_vol * 1.0e4f);

  return form_factor;
}

float Iq(float q, float radius, float edge_sep, float num_pearls, float pearl_sld, float solvent_sld) {
  float result = linear_pearls_kernel(q, radius, edge_sep, num_pearls, pearl_sld, solvent_sld);

  return result;
}

float Iqxy(float qx, float qy, float radius, float edge_sep, float num_pearls, float pearl_sld, float solvent_sld) {
  float q;
  q = sqrt(qx * qx + qy * qy);

  float result = linear_pearls_kernel(q, radius, edge_sep, num_pearls, pearl_sld, solvent_sld);

  return result;
}
kernel void linear_pearls_Iqxy(global const float* qx, global const float* qy, global float* result, const int Nq, const float scale, const float background, const float radius, const float edge_sep, const float num_pearls, const float pearl_sld, const float solvent_sld) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qxi = qx[hook(0, i)];
    const float qyi = qy[hook(1, i)];
    result[hook(2, i)] = scale * Iqxy(qxi, qyi, radius, edge_sep, num_pearls, pearl_sld, solvent_sld) + background;
  }
}