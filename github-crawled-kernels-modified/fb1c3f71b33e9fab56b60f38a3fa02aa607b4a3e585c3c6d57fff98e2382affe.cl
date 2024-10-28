//{"dst_data":1,"flipx":4,"flipy":5,"ht":3,"src_data":0,"swapxy":6,"wd":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void image_transform_uint32(global unsigned int* src_data, global unsigned int* dst_data, int wd, int ht, int flipx, int flipy, int swapxy) {
  const int ix = get_global_id(1);
  const int iy = get_global_id(0);

  int dst_x = ix;
  int dst_y = iy;

  if (flipy != 0) {
    dst_y = ht - 1 - iy;
  }

  if (flipx != 0) {
    dst_x = wd - 1 - ix;
  }

  if (swapxy != 0) {
    dst_data[hook(1, dst_x * ht + dst_y)] = src_data[hook(0, iy * wd + ix)];
  } else {
    dst_data[hook(1, dst_y * wd + dst_x)] = src_data[hook(0, iy * wd + ix)];
  }
}