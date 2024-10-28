//{"img_sqsums":0,"img_sqsums_offset":7,"img_sqsums_step":8,"res":1,"res_cols":4,"res_offset":9,"res_rows":3,"res_step":10,"tpl_cols":6,"tpl_rows":5,"tpl_sqsum":2}
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

kernel void matchTemplate_Prepared_SQDIFF_C1_D0(global const float* img_sqsums, global float* res, ulong tpl_sqsum, int res_rows, int res_cols, int tpl_rows, int tpl_cols, int img_sqsums_offset, int img_sqsums_step, int res_offset, int res_step) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  res_step /= sizeof(*res);
  res_offset /= sizeof(*res);
  img_sqsums_step /= sizeof(*img_sqsums);
  img_sqsums_offset /= sizeof(*img_sqsums);
  int res_idx = mad24(gidy, res_step, res_offset + gidx);
  if (gidx < res_cols && gidy < res_rows) {
    float image_sqsum_ = (float)((img_sqsums[hook(0, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))] - img_sqsums[hook(0, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + tpl_cols) * 1))]) - (img_sqsums[hook(0, mad24(gidy + tpl_rows, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))] - img_sqsums[hook(0, mad24(gidy + 0, img_sqsums_step, (gidx + img_sqsums_offset + 0) * 1))]));
    res[hook(1, res_idx)] = image_sqsum_ - 2.f * res[hook(1, res_idx)] + tpl_sqsum;
  }
}