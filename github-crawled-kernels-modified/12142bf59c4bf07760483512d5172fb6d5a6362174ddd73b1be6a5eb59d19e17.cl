//{"cache":6,"dest":1,"dst_step":3,"height":5,"source":0,"src_step":2,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) __attribute__((reqd_work_group_size(16, 16, 1))) kernel void dilate15_cached(global const uchar* source, global uchar* dest, int src_step, int dst_step, int width, int height) {
  const int gx = get_global_id(0);
  const int gy = get_global_id(1);
  src_step /= sizeof(uchar);
  dst_step /= sizeof(uchar);
  const int lid = get_local_id(1) * get_local_size(0) + get_local_id(0);
  uchar Value = source[hook(0, gy * src_step + gx)];
  local uchar cache[16 * 16];
  cache[hook(6, lid)] = Value;
  barrier(0x01);
  int bitmask = 16 - 1;
  int x_cache_begin = gx - (gx & bitmask);
  int x_cache_end = x_cache_begin + 16;
  int y_cache_begin = gy - (gy & bitmask);
  int y_cache_end = y_cache_begin + 16;
  const int mask_size = 15 / 2;
  if (gy - mask_size < 0 || gy + mask_size >= height || gx - mask_size < 0 || gx + mask_size >= width) {
    dest[hook(1, gy * dst_step + gx)] = Value;
    return;
  }
  for (int y = -mask_size; y <= mask_size; y++) {
    int py = gy + y;
    if (py < y_cache_begin || py >= y_cache_end) {
      for (int x = -mask_size; x <= mask_size; x++) {
        uchar Val = source[hook(0, py * src_step + gx + x)];
        Value = max(Val, Value);
      }
    } else {
      for (int x = -mask_size; x <= mask_size; x++) {
        int px = gx + x;
        uchar Val;
        if (px < x_cache_begin || px >= x_cache_end)
          Val = source[hook(0, py * src_step + px)];
        else {
          int cache_y = py - y_cache_begin;
          int cache_x = px - x_cache_begin;
          Val = cache[hook(6, cache_y * 16 + cache_x)];
        }
        Value = max(Val, Value);
      }
    }
  }
  dest[hook(1, gy * dst_step + gx)] = Value;
}