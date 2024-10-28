//{"begin":1,"num_elements":2,"output_buffer":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float quartic_polynomial3d(float r, float h) {
  float h_inv = 1.f / h;

  float norm = 1.04445f * h_inv * h_inv * h_inv;
  float q = fmin(r * h_inv, 1.f);
  float q2 = q * q;
  float q4 = q2 * q2;

  return norm * (1.f + q4 - 2.f * q2);
}

float quartic_polynomial3d_cutoff_radius(float h) {
  return h;
}

float quartic_polynomial3d_projection(float r, float h) {
  float h_inv = 1.f / h;
  float h_inv3 = h_inv * h_inv * h_inv;

  float norm = 1.04445f * h_inv3;

  float h4 = h * h * h * h;
  float s2 = fmax(h * h - r * r, 0.0f);

  float integral = 1.066667f * s2 * s2 * sqrt(s2) * h_inv * h_inv3;

  return 2.f * norm * integral;
}

float cubic_spline3d(float r, float h) {
  float q = r / h;
  if (q > 2.f)
    return 0.0f;

  float norm = 1.f / (3.14159265358979323846264338327950288f * h * h * h);

  if (q <= 1) {
    float q2 = q * q;
    float q3 = q * q2;
    return norm * (1.f - 1.5f * q2 + 0.75f * q3);
  } else {
    float two_minus_q = 2.f - q;
    return norm * 0.25f * two_minus_q * two_minus_q * two_minus_q;
  }
}

float cubic_spline3d_cutoff_radius(float h) {
  return 2.f * h;
}
kernel void util_create_sequence(global unsigned long* output_buffer, unsigned long begin, unsigned long num_elements) {
  size_t tid = get_global_id(0);

  if (tid < num_elements) {
    output_buffer[hook(0, tid)] = begin + tid;
  }
}