//{"alphas":2,"dimension":5,"height_ori":3,"intensities_nl":0,"nlooks":6,"weighted_variances":1,"width_ori":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_alphas(global float* intensities_nl, global float* weighted_variances, global float* alphas, const int height_ori, const int width_ori, const int dimension, const int nlooks) {
  const int tx = get_group_id(0) * get_local_size(0) + get_local_id(0);
  const int ty = get_group_id(1) * get_local_size(1) + get_local_id(1);

  float alpha = 0.0f;

  if (tx < height_ori && ty < width_ori) {
    const int idx = tx * width_ori + ty;
    for (int d = 0; d < dimension; d++) {
      const float var = weighted_variances[hook(1, d * height_ori * width_ori + idx)];
      const float int_nl = intensities_nl[hook(0, d * height_ori * width_ori + idx)];
      alpha = max(alpha, max(0.0f, (var - int_nl * int_nl / nlooks) / var));
    }
    alphas[hook(2, tx * width_ori + ty)] = alpha;
  }
}