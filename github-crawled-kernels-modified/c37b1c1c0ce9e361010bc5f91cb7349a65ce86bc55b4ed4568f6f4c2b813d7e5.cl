//{"cols":3,"img":0,"img_offset":4,"img_step":6,"res":1,"res_offset":5,"res_step":7,"rows":2}
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

kernel void extractFirstChannel(const global float4* img, global float* res, int rows, int cols, int img_offset, int res_offset, int img_step, int res_step) {
  img_step /= sizeof(float4);
  res_step /= sizeof(float);
  img_offset /= sizeof(float4);
  res_offset /= sizeof(float);
  img += img_offset;
  res += res_offset;
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  if (gidx < cols && gidy < rows) {
    res[hook(1, gidx + gidy * res_step)] = img[hook(0, gidx + gidy * img_step)].x;
  }
}