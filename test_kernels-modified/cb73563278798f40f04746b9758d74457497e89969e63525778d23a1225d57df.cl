//{"cluster_contents":3,"cluster_labels":1,"cluster_sizes":2,"hyper_param":4,"loglik":5,"obs_index":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float t_logpdf(float theta, float df, float loc, float scale) {
  float part1 = lgamma((df + 1) / 2.0) - lgamma(0.5 * df) - log(pow(df * 3.14159265358979323846264338327950288f, (float)0.5) * scale);
  float part2 = -0.5 * (df + 1) * log(1 + (1 / df) * pow((theta - loc) / scale, (float)2.0));
  return part1 + part2;
}

kernel void loglikelihood(int obs_index, global int* cluster_labels, constant int* cluster_sizes, constant float* cluster_contents, constant float* hyper_param, global float* loglik) {
  int i = get_global_id(0);
  if (cluster_labels[hook(1, i)] > -1) {
    int n = cluster_sizes[hook(2, i)];
    float gaussian_mu0 = hyper_param[hook(4, 0)];
    float gaussian_k0 = hyper_param[hook(4, 1)];
    float gamma_alpha0 = hyper_param[hook(4, 2)];
    float gamma_beta0 = hyper_param[hook(4, 3)];
    float sum = 0;
    float ss = 0;
    float y_bar = 0;

    for (int j = i; j < i + cluster_sizes[hook(2, i)]; j++) {
      if (j == obs_index) {
        n = n - 1;
        if (n == 0) {
          cluster_labels[hook(1, i)] = -1;
          return;
        }
      } else {
        sum += cluster_contents[hook(3, j)];
      }
    }
    if (n > 0) {
      y_bar = sum / n;
    }

    for (int j = i; j < i + cluster_sizes[hook(2, i)]; j++) {
      if (j != obs_index)
        ss += pow(cluster_contents[hook(3, j)] - y_bar, (float)2.0);
    }

    float k_n = gaussian_k0 + n;
    float mu_n = (gaussian_k0 * gaussian_mu0 + n * y_bar) / k_n;
    float alpha_n = gamma_alpha0 + n / 2.0;
    float beta_n = gamma_beta0 + 0.5 * ss + gaussian_k0 * n * pow((y_bar - gaussian_mu0), (float)2.0) / (2.0 * k_n);
    float Lambda = alpha_n * k_n / (beta_n * (k_n + 1));
    float sigma = pow(1 / Lambda, (float)0.5);
    loglik[hook(5, i)] = t_logpdf(cluster_contents[hook(3, obs_index)], 2.0 * alpha_n, mu_n, sigma);
  }
}