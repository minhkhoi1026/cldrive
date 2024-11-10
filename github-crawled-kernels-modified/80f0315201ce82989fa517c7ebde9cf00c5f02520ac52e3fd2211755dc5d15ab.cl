//{"dst":0,"dst_step":1,"src":2,"src_cols":3,"src_rows":4,"src_step":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Img8uToImg32f_cl(global float* dst, int dst_step, global unsigned char* src, int src_cols, int src_rows, int src_step) {
  int i = 2 * get_global_id(0);
  int j = 2 * get_global_id(1);

  if (i + 1 >= src_cols)
    i--;
  if (j + 1 >= src_rows)
    j--;
  if (i + 1 >= src_cols || j + 1 >= src_rows)
    return;

  const int src_offset = j * src_step + i;
  const int dst_offset = j * dst_step + i;

  src += src_offset;
  dst += dst_offset;
  *(dst + 0) = (float)*(src + 0);
  *(dst + 1) = (float)*(src + 1);

  src += src_step;
  dst += dst_step;
  *(dst + 0) = (float)*(src + 0);
  *(dst + 1) = (float)*(src + 1);
}