//{"Nq":2,"background":4,"cluster_rg":7,"mass_dim":5,"primary_rg":8,"q":0,"result":1,"scale":3,"surface_dim":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float form_volume(float radius);
float Iq(float q, float mass_dim, float surface_dim, float cluster_rg, float primary_rg);
float Iqxy(float qx, float qy, float mass_dim, float surface_dim, float cluster_rg, float primary_rg);
float _mass_surface_fractal_kernel(float q, float mass_dim, float surface_dim, float cluster_rg, float primary_rg) {
  float tot_dim = 6.0f - surface_dim - mass_dim;
  mass_dim /= 2.0f;
  tot_dim /= 2.0f;

  float rc_norm = cluster_rg * cluster_rg / (3.0f * mass_dim);
  float rp_norm = primary_rg * primary_rg / (3.0f * tot_dim);

  float x_val1 = 1.0f + q * q * rc_norm;
  float x_val2 = 1.0f + q * q * rp_norm;

  float inv_form = pow(x_val1, mass_dim) * pow(x_val2, tot_dim);

  if (inv_form == 0.0f)
    return 0.0f;

  float form_factor = 1.0f;
  form_factor /= inv_form;

  return (form_factor);
}
float form_volume(float radius) {
  return 1.333333333333333f * 3.14159265358979323846f * radius * radius * radius;
}

float Iq(float q, float mass_dim, float surface_dim, float cluster_rg, float primary_rg) {
  return _mass_surface_fractal_kernel(q, mass_dim, surface_dim, cluster_rg, primary_rg);
}

float Iqxy(float qx, float qy, float mass_dim, float surface_dim, float cluster_rg, float primary_rg) {
  float q = sqrt(qx * qx + qy * qy);
  return _mass_surface_fractal_kernel(q, mass_dim, surface_dim, cluster_rg, primary_rg);
}
kernel void mass_surface_fractal_Iq(global const float* q, global float* result, const int Nq, const float scale, const float background, const float mass_dim, const float surface_dim, const float cluster_rg, const float primary_rg) {
  int i = get_global_id(0);
  if (i < Nq)

  {
    const float qi = q[hook(0, i)];
    result[hook(1, i)] = scale * Iq(qi, mass_dim, surface_dim, cluster_rg, primary_rg) + background;
  }
}