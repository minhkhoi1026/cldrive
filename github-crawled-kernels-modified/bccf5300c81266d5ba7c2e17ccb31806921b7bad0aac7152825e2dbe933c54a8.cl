//{"color1":1,"color2":2,"out":0,"square_height":4,"square_width":3,"x_offset":5,"y_offset":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline int tile_index(int float4, int stride) {
  int a = (float4 < 0);
  return ((float4 + a) / stride) - a;
}

kernel void kernel_checkerboard(global float4* out, float4 color1, float4 color2, int square_width, int square_height, int x_offset, int y_offset) {
  size_t roi_width = get_global_size(0);
  size_t roi_x = get_global_offset(0);
  size_t roi_y = get_global_offset(1);
  size_t gidx = get_global_id(0) - roi_x;
  size_t gidy = get_global_id(1) - roi_y;

  int x = get_global_id(0) - x_offset;
  int y = get_global_id(1) - y_offset;

  int tilex = tile_index(x, square_width);
  int tiley = tile_index(y, square_height);
  out[hook(0, gidx + gidy * roi_width)] = (tilex + tiley) & 1 ? color2 : color1;
}