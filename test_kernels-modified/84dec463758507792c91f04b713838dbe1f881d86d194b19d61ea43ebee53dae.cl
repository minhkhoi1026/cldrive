//{"alpha":4,"cluster_labels":2,"cluster_sizes":3,"logprior":5,"obs_index":0,"total_n":1}
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

kernel void logprior(int obs_index, float total_n, global int* cluster_labels, constant int* cluster_sizes, float alpha, global float* logprior) {
  int i = get_global_id(0);
  int n = cluster_sizes[hook(3, i)];
  int old_group = 0;
  if (cluster_labels[hook(2, i)] > -1) {
    if (obs_index >= i && obs_index < i + cluster_sizes[hook(3, i)]) {
      old_group = 1;
      n = n - 1;
    }
    if (old_group == 1 & n == 0) {
      cluster_labels[hook(2, i)] = -1;
      return;
    }
    if (old_group == 0 & n == 0) {
      logprior[hook(5, i)] = log(alpha / (total_n + alpha));
    } else {
      logprior[hook(5, i)] = log(n / (total_n + alpha));
    }
  }
}