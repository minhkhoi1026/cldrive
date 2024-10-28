//{"dst":0,"dst_step":1,"rk0":4,"rk1":5,"rk2":6,"src":2,"src_step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ImgRowBlur_cl(global float* dst, int dst_step, global float* src, int src_step, float rk0, float rk1, float rk2) {
  int i = get_global_id(0);
  int j = get_global_id(1);

  if (i + 2 >= src_step)
    i = src_step - 3;

  const int src_offset = j * src_step + i;
  const int dst_offset = j * dst_step + i;

  src += src_offset;
  dst += dst_offset;

  *dst = *src++ * rk0 + *src++ * rk1 + *src * rk2;
}