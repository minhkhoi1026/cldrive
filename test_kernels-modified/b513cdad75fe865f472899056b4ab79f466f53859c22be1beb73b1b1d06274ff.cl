//{"d_call_price_":1,"d_put_price_":2,"offset":3,"rand_array":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float Phi(float X) {
  float y, absX, t;

  const float c1 = 0.319381530f;
  const float c2 = -0.356563782f;
  const float c3 = 1.781477937f;
  const float c4 = -1.821255978f;
  const float c5 = 1.330274429f;

  const float oneBySqrt2pi = 0.398942280f;

  absX = fabs(X);
  t = 1.0f / (1.0f + 0.2316419f * absX);

  y = 1.0f - oneBySqrt2pi * exp(-X * X / 2.0f) * t * (c1 + t * (c2 + t * (c3 + t * (c4 + t * c5))));

  return (X < 0) ? (1.0f - y) : y;
}

kernel void bs_cl12(global float* rand_array, global float* d_call_price_, global float* d_put_price_, int offset) {
  rand_array = rand_array + offset;
  d_call_price_ = d_call_price_ + offset;
  d_put_price_ = d_put_price_ + offset;
  unsigned int tid = get_global_id(0);

  float i_rand = rand_array[hook(0, tid)];

  float s = 10.0 * i_rand + 100.0 * (1.0f - i_rand);
  float k = 10.0 * i_rand + 100.0 * (1.0f - i_rand);
  float t = 1.0 * i_rand + 10.0 * (1.0f - i_rand);
  float r = 0.01 * i_rand + 0.05 * (1.0f - i_rand);
  float sigma = 0.01 * i_rand + 0.10 * (1.0f - i_rand);

  float sigma_sqrt_t_ = sigma * sqrt(t);

  float d1 = (log(s / k) + (r + sigma * sigma / 2.0f) * t) / sigma_sqrt_t_;
  float d2 = d1 - sigma_sqrt_t_;

  float k_exp_minus_rt_ = k * exp(-r * t);

  d_call_price_[hook(1, tid)] = s * Phi(d1) - k_exp_minus_rt_ * Phi(d2);
  d_put_price_[hook(2, tid)] = k_exp_minus_rt_ * Phi(-d2) - s * Phi(-d1);
}