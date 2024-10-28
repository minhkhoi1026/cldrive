//{"dst":0,"dst_step":1,"src":2,"src_cols":3,"src_rows":4,"src_step":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Img8uBGRAToImg32fGRAY_cl(global float* dst, int dst_step, global unsigned char* src, int src_cols, int src_rows, int src_step) {
  int i = 2 * get_global_id(0);
  int j = 2 * get_global_id(1);

  if (i + 1 >= src_cols)
    i--;
  if (j + 1 >= src_rows)
    j--;
  if (i + 1 >= src_cols || j + 1 >= src_rows)
    return;

  const int src_offset = j * src_step + 4 * i;
  const int dst_offset = j * dst_step + i;

  src += src_offset;
  dst += dst_offset;
  float B = (float)*(src + 0);
  float G = (float)*(src + 1);
  float R = (float)*(src + 2);
  *(dst + 0) = B * 0.114f + G * 0.587f + R * 0.299f;

  B = (float)*(src + 4 + 0);
  G = (float)*(src + 4 + 1);
  R = (float)*(src + 4 + 2);
  *(dst + 1) = B * 0.114f + G * 0.587f + R * 0.299f;

  src += src_step;
  dst += dst_step;
  B = (float)*(src + 0);
  G = (float)*(src + 1);
  R = (float)*(src + 2);
  *(dst + 0) = B * 0.114f + G * 0.587f + R * 0.299f;

  B = (float)*(src + 4 + 0);
  G = (float)*(src + 4 + 1);
  R = (float)*(src + 4 + 2);
  *(dst + 1) = B * 0.114f + G * 0.587f + R * 0.299f;
}