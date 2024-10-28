//{"img_cols":2,"img_rows":1,"img_sqsums":13,"img_sqsums_offset":14,"img_sqsums_step":15,"img_sums":10,"img_sums_offset":11,"img_sums_step":12,"res":0,"res_cols":6,"res_offset":7,"res_rows":5,"res_step":8,"tpl_cols":4,"tpl_rows":3,"tpl_sqsum":17,"tpl_sum":16,"weight":9}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float normAcc(float num, float denum) {
  if (fabs(num) < denum) {
    return num / denum;
  }
  if (fabs(num) < denum * 1.125f) {
    return num > 0 ? 1 : -1;
  }
  return 0;
}

inline float normAcc_SQDIFF(float num, float denum) {
  if (fabs(num) < denum) {
    return num / denum;
  }
  if (fabs(num) < denum * 1.125f) {
    return num > 0 ? 1 : -1;
  }
  return 1;
}

kernel void matchTemplate_Prepared_CCOFF_NORMED_C1_D0(global float* res, int img_rows, int img_cols, int tpl_rows, int tpl_cols, int res_rows, int res_cols, int res_offset, int res_step, float weight, global const unsigned int* img_sums, int img_sums_offset, int img_sums_step, global const float* img_sqsums, int img_sqsums_offset, int img_sqsums_step, float tpl_sum, float tpl_sqsum) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  img_sqsums_step /= sizeof(*img_sqsums);
  img_sqsums_offset /= sizeof(*img_sqsums);
  img_sums_offset /= sizeof(*img_sums);
  img_sums_step /= sizeof(*img_sums);
  res_step /= sizeof(*res);
  res_offset /= sizeof(*res);

  int res_idx = mad24(gidy, res_step, res_offset + gidx);

  if (gidx < res_cols && gidy < res_rows) {
    float image_sum_ = (float)((img_sums[hook(10, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + tpl_cols))] - img_sums[hook(10, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + tpl_cols))]) - (img_sums[hook(10, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + 0))] - img_sums[hook(10, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + 0))]));

    float image_sqsum_ = (float)((img_sqsums[hook(13, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))] - img_sqsums[hook(13, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))]) - (img_sqsums[hook(13, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))] - img_sqsums[hook(13, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))]));
    res[hook(0, res_idx)] = normAcc(res[hook(0, res_idx)] - image_sum_ * tpl_sum, sqrt(tpl_sqsum * (image_sqsum_ - weight * image_sum_ * image_sum_)));
  }
}