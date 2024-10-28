//{"dst":8,"dst_base":3,"dst_offset":4,"dst_stride":5,"num_bytes":6,"num_iter":7,"src":9,"src_base":0,"src_offset":1,"src_stride":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant int bilinear_filters[8 * 2] = {128, 0, 112, 16, 96, 32, 80, 48, 64, 64, 48, 80, 32, 96, 16, 112};

constant short8 sub_pel_filters[8] = {

    {0, 0, 128, 0, 0, 0, 0, 0}, {0, -6, 123, 12, -1, 0, 0, 0}, {2, -11, 108, 36, -8, 1, 0, 0}, {0, -9, 93, 50, -6, 0, 0, 0}, {3, -16, 77, 77, -16, 3, 0, 0}, {0, -6, 50, 93, -9, 0, 0, 0}, {1, -8, 36, 108, -11, 2, 0, 0}, {0, -1, 12, 123, -6, 0, 0, 0}};

__inline short8 sub_pel_filter_values(int offset, constant short8* sub_pel_filters) {
  short8 result = 0;
  switch (offset) {
    case 0:
      result.s2 = 128;
      break;
    case 1:
      result.s1 = -6;
      result.s2 = 123;
      result.s3 = 12;
      result.s4 = -1;
      break;
    case 2:
      result.s0 = 2;
      result.s1 = -11;
      result.s2 = 108;
      result.s3 = 36;
      result.s4 = -8;
      result.s5 = 1;
      break;
    case 3:
      result.s1 = -9;
      result.s2 = 93;
      result.s3 = 50;
      result.s4 = -6;
      break;
    case 4:
      result.s0 = 3;
      result.s1 = -16;
      result.s2 = 77;
      result.s3 = 77;
      result.s4 = -16;
      result.s5 = 3;
      break;
    case 5:
      result.s1 = -6;
      result.s2 = 50;
      result.s3 = 93;
      result.s4 = -9;
      break;
    case 6:
      result.s0 = 1;
      result.s1 = -8;
      result.s2 = 36;
      result.s3 = 108;
      result.s4 = -11;
      result.s5 = 2;
      break;
    case 7:
      result.s1 = -1;
      result.s2 = 12;
      result.s3 = 123;
      result.s4 = -6;
      break;
    default:
      break;
  }
  return result;
}

kernel void vp8_memcpy_kernel(global unsigned char* src_base, int src_offset, int src_stride, global unsigned char* dst_base, int dst_offset, int dst_stride, int num_bytes, int num_iter) {
  int i, r;
  global unsigned char* src = &src_base[hook(0, src_offset)];
  global unsigned char* dst = &dst_base[hook(3, dst_offset)];
  src_offset = dst_offset = 0;

  r = get_global_id(1);
  if (r < get_global_size(1)) {
    i = get_global_id(0);
    if (i < get_global_size(0)) {
      src_offset = r * src_stride + i;
      dst_offset = r * dst_stride + i;
      dst[hook(8, dst_offset)] = src[hook(9, src_offset)];
    }
  }
}