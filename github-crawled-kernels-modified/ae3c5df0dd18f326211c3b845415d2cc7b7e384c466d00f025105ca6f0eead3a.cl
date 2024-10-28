//{"img":0,"img_cols":4,"img_offset":9,"img_ptr":15,"img_rows":3,"img_step":12,"res":2,"res_cols":8,"res_offset":11,"res_rows":7,"res_step":14,"tpl":1,"tpl_cols":6,"tpl_offset":10,"tpl_ptr":16,"tpl_rows":5,"tpl_step":13}
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

kernel void matchTemplate_Naive_CCORR_C1_D0(global const uchar* img, global const uchar* tpl, global float* res, int img_rows, int img_cols, int tpl_rows, int tpl_cols, int res_rows, int res_cols, int img_offset, int tpl_offset, int res_offset, int img_step, int tpl_step, int res_step) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int i, j;
  int sum = 0;
  res_step /= sizeof(*res);
  res_offset /= sizeof(*res);

  int res_idx = mad24(gidy, res_step, res_offset + gidx);

  if (gidx < res_cols && gidy < res_rows) {
    for (i = 0; i < tpl_rows; i++) {
      global const uchar* img_ptr = img + mad24(gidy + i, img_step, gidx + img_offset);
      global const uchar* tpl_ptr = tpl + mad24(i, tpl_step, tpl_offset);
      for (j = 0; j < tpl_cols; j++) {
        sum = mad24(convert_int(img_ptr[hook(15, j)]), convert_int(tpl_ptr[hook(16, j)]), sum);
      }
    }
    res[hook(2, res_idx)] = (float)sum;
  }
}