//{"ck0":4,"ck1":5,"ck2":6,"dst":0,"dst_step":1,"src":2,"src_step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ImgColBlur_cl(global float* dst, int dst_step, global float* src, int src_step, float ck0, float ck1, float ck2) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);

  const int src_offset = j * src_step + i;
  const int dst_offset = j * dst_step + i;

  src += src_offset;
  dst += dst_offset;

  *dst = *src * ck0 + *(src + src_step) * ck1 + *(src + 2 * src_step) * ck2;
}