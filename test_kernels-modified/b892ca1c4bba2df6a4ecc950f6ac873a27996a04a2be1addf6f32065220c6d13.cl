//{"c":7,"chi2cdf_inv":9,"dissims2relidx":8,"dissims_max":12,"dissims_min":11,"h":6,"height_symm":2,"lut_size":10,"patch_similarities":0,"patch_size":5,"search_window_size":4,"weights":1,"width_symm":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute_weights(global float* patch_similarities, global float* weights, const int height_symm, const int width_symm, const int search_window_size, const int patch_size, const float h, const float c, constant float* dissims2relidx, constant float* chi2cdf_inv, const int lut_size, const float dissims_min, const float dissims_max) {
  const int tx = get_global_id(0);

  const int wsh = (search_window_size - 1) / 2;

  if (tx < (search_window_size * wsh + wsh) * height_symm * width_symm) {
    float dissim = patch_similarities[hook(0, tx)];

    if (dissim > dissims_max) {
      weights[hook(1, tx)] = 0.0f;
    } else {
      dissim = max(dissim, dissims_min);
      dissim = min(dissim, dissims_max);

      const float mapped_idx = (dissim - dissims_min) / (dissims_max - dissims_min) * (lut_size - 1);

      const float quantile = dissims2relidx[hook(8, (unsigned int)mapped_idx)];
      const float x = chi2cdf_inv[hook(9, (unsigned int)(quantile * (lut_size - 1)))];
      const float weight = exp(-fabs(x - c) / h);

      weights[hook(1, tx)] = weight;
    }
  }
}