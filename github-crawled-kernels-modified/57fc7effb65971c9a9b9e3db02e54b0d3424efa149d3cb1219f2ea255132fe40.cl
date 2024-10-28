//{"h":3,"in":0,"offset":1,"out":4,"w":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_displacement_map_element(const global unsigned int* in, const global unsigned int* offset, int w, int h, global unsigned int* out) {
  const int cx = get_global_id(0);
  const int cy = get_global_id(1);
  unsigned int c = offset[hook(1, cy * w + cx)];
  int x_pos = cx + c;
  int y_pos = cy + c;
  if (0 <= x_pos && x_pos < w && 0 <= y_pos && y_pos < h)
    out[hook(4, cy * w + cx)] = in[hook(0, y_pos * w + x_pos)];
  else
    out[hook(4, cy * w + cx)] = 0;
}