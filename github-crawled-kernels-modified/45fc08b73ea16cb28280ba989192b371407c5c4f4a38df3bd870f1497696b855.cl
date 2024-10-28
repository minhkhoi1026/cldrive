//{"cols":10,"dst":13,"dst_offset":8,"dst_step":7,"dstptr":6,"lut":12,"lut_l":11,"lut_offset":5,"lut_step":4,"lutptr":3,"rows":9,"src_offset":2,"src_step":1,"srcptr":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void LUT(global const uchar* srcptr, int src_step, int src_offset, global const uchar* lutptr, int lut_step, int lut_offset, global uchar* dstptr, int dst_step, int dst_offset, int rows, int cols) {
  int x = get_global_id(0);
  int y = get_global_id(1) << 2;
  local uchar lut_l[256 * 3];
  global const uchar* lut = (global const uchar*)(lutptr + lut_offset);
  for (int i = mad24((int)get_local_id(1), (int)get_local_size(0), (int)get_local_id(0)), step = get_local_size(0) * get_local_size(1); i < 256 * 3; i += step)
    lut_l[hook(11, i)] = lut[hook(12, i)];
  barrier(0x01);
  if (x < cols && y < rows) {
    int src_index = mad24(y, src_step, mad24(x, (int)sizeof(char) * 3, src_offset));
    int dst_index = mad24(y, dst_step, mad24(x, (int)sizeof(uchar) * 3, dst_offset));
    global uchar* dst;
    uchar3 src_pixel = vload3(0, srcptr + src_index);
    int3 idx = mad24(convert_int3(src_pixel), (int3)(3), (int3)(0, 1, 2));
    dst = (global uchar*)(dstptr + dst_index);
    dst[hook(13, 0)] = lut_l[hook(11, idx.x)];
    dst[hook(13, 1)] = lut_l[hook(11, idx.y)];
    dst[hook(13, 2)] = lut_l[hook(11, idx.z)];
    ;
    if (y < rows - 1) {
      src_index += src_step;
      dst_index += dst_step;
      uchar3 src_pixel = vload3(0, srcptr + src_index);
      int3 idx = mad24(convert_int3(src_pixel), (int3)(3), (int3)(0, 1, 2));
      dst = (global uchar*)(dstptr + dst_index);
      dst[hook(13, 0)] = lut_l[hook(11, idx.x)];
      dst[hook(13, 1)] = lut_l[hook(11, idx.y)];
      dst[hook(13, 2)] = lut_l[hook(11, idx.z)];
      ;
      if (y < rows - 2) {
        src_index += src_step;
        dst_index += dst_step;
        uchar3 src_pixel = vload3(0, srcptr + src_index);
        int3 idx = mad24(convert_int3(src_pixel), (int3)(3), (int3)(0, 1, 2));
        dst = (global uchar*)(dstptr + dst_index);
        dst[hook(13, 0)] = lut_l[hook(11, idx.x)];
        dst[hook(13, 1)] = lut_l[hook(11, idx.y)];
        dst[hook(13, 2)] = lut_l[hook(11, idx.z)];
        ;
        if (y < rows - 3) {
          src_index += src_step;
          dst_index += dst_step;
          uchar3 src_pixel = vload3(0, srcptr + src_index);
          int3 idx = mad24(convert_int3(src_pixel), (int3)(3), (int3)(0, 1, 2));
          dst = (global uchar*)(dstptr + dst_index);
          dst[hook(13, 0)] = lut_l[hook(11, idx.x)];
          dst[hook(13, 1)] = lut_l[hook(11, idx.y)];
          dst[hook(13, 2)] = lut_l[hook(11, idx.z)];
          ;
        }
      }
    }
  }
}