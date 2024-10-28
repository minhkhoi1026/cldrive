//{"img_cols":2,"img_rows":1,"img_sums":9,"img_sums_offset":10,"img_sums_step":11,"res":0,"res_cols":6,"res_offset":7,"res_rows":5,"res_step":8,"tpl_cols":4,"tpl_rows":3,"tpl_sum":12}
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

kernel void matchTemplate_Prepared_CCOFF_C1_D0(global float* res, int img_rows, int img_cols, int tpl_rows, int tpl_cols, int res_rows, int res_cols, int res_offset, int res_step, global const unsigned int* img_sums, int img_sums_offset, int img_sums_step, float tpl_sum) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);

  img_sums_offset /= sizeof(*img_sums);
  img_sums_step /= sizeof(*img_sums);
  res_step /= sizeof(*res);
  res_offset /= sizeof(*res);

  int res_idx = mad24(gidy, res_step, res_offset + gidx);

  if (gidx < res_cols && gidy < res_rows) {
    float sum = (float)((img_sums[hook(9, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + tpl_cols))] - img_sums[hook(9, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + tpl_cols))]) - (img_sums[hook(9, mad24(gidy + tpl_rows, img_sums_step, gidx + img_sums_offset + 0))] - img_sums[hook(9, mad24(gidy + 0, img_sums_step, gidx + img_sums_offset + 0))]));
    res[hook(0, res_idx)] -= sum * tpl_sum;
  }
}