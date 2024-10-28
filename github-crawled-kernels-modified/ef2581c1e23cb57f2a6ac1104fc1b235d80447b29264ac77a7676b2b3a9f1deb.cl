//{"img_cols":2,"img_rows":1,"img_sqsums_c0":16,"img_sqsums_c1":17,"img_sqsums_c2":18,"img_sqsums_c3":19,"img_sqsums_offset":20,"img_sqsums_step":21,"img_sums_c0":10,"img_sums_c1":11,"img_sums_c2":12,"img_sums_c3":13,"img_sums_offset":14,"img_sums_step":15,"res":0,"res_cols":6,"res_offset":7,"res_rows":5,"res_step":8,"tpl_cols":4,"tpl_rows":3,"tpl_sqsum":26,"tpl_sum_c0":22,"tpl_sum_c1":23,"tpl_sum_c2":24,"tpl_sum_c3":25,"weight":9}
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

kernel void matchTemplate_Prepared_CCOFF_NORMED_C4_D0(global float* res, int img_rows, int img_cols, int tpl_rows, int tpl_cols, int res_rows, int res_cols, int res_offset, int res_step, float weight, global const unsigned int* img_sums_c0, global const unsigned int* img_sums_c1, global const unsigned int* img_sums_c2, global const unsigned int* img_sums_c3, int img_sums_offset, int img_sums_step, global const float* img_sqsums_c0, global const float* img_sqsums_c1, global const float* img_sqsums_c2, global const float* img_sqsums_c3, int img_sqsums_offset, int img_sqsums_step, float tpl_sum_c0, float tpl_sum_c1, float tpl_sum_c2, float tpl_sum_c3, float tpl_sqsum) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  img_sqsums_step /= sizeof(*img_sqsums_c0);
  img_sqsums_offset /= sizeof(*img_sqsums_c0);
  img_sums_offset /= sizeof(*img_sums_c0);
  img_sums_step /= sizeof(*img_sums_c0);
  res_step /= sizeof(*res);
  res_offset /= sizeof(*res);

  int res_idx = mad24(gidy, res_step, res_offset + gidx);

  if (gidx < res_cols && gidy < res_rows) {
    float image_sum_c0 = (float)((img_sums_c0[hook(10, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + tpl_cols))] - img_sums_c0[hook(10, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + tpl_cols))]) - (img_sums_c0[hook(10, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + 0))] - img_sums_c0[hook(10, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + 0))]));
    float image_sum_c1 = (float)((img_sums_c1[hook(11, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + tpl_cols))] - img_sums_c1[hook(11, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + tpl_cols))]) - (img_sums_c1[hook(11, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + 0))] - img_sums_c1[hook(11, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + 0))]));
    float image_sum_c2 = (float)((img_sums_c2[hook(12, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + tpl_cols))] - img_sums_c2[hook(12, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + tpl_cols))]) - (img_sums_c2[hook(12, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + 0))] - img_sums_c2[hook(12, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + 0))]));
    float image_sum_c3 = (float)((img_sums_c3[hook(13, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + tpl_cols))] - img_sums_c3[hook(13, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + tpl_cols))]) - (img_sums_c3[hook(13, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + 0))] - img_sums_c3[hook(13, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + 0))]));

    float image_sqsum_c0 = (float)((img_sqsums_c0[hook(16, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))] - img_sqsums_c0[hook(16, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))]) - (img_sqsums_c0[hook(16, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))] - img_sqsums_c0[hook(16, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))]));
    float image_sqsum_c1 = (float)((img_sqsums_c1[hook(17, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))] - img_sqsums_c1[hook(17, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))]) - (img_sqsums_c1[hook(17, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))] - img_sqsums_c1[hook(17, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))]));
    float image_sqsum_c2 = (float)((img_sqsums_c2[hook(18, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))] - img_sqsums_c2[hook(18, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))]) - (img_sqsums_c2[hook(18, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))] - img_sqsums_c2[hook(18, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))]));
    float image_sqsum_c3 = (float)((img_sqsums_c3[hook(19, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))] - img_sqsums_c3[hook(19, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))]) - (img_sqsums_c3[hook(19, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))] - img_sqsums_c3[hook(19, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))]));

    float num = res[hook(0, res_idx)] - image_sum_c0 * tpl_sum_c0 - image_sum_c1 * tpl_sum_c1 - image_sum_c2 * tpl_sum_c2 - image_sum_c3 * tpl_sum_c3;
    float denum = sqrt(tpl_sqsum * (image_sqsum_c0 - weight * image_sum_c0 * image_sum_c0 + image_sqsum_c1 - weight * image_sum_c1 * image_sum_c1 + image_sqsum_c2 - weight * image_sum_c2 * image_sum_c2 + image_sqsum_c3 - weight * image_sum_c0 * image_sum_c3));
    res[hook(0, res_idx)] = normAcc(num, denum);
  }
}