//{"dest":1,"height":3,"mask":0,"offset_y":4,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mask(global float* mask, global float* dest, int width, int height, int offset_y) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x < width && y < height) {
    const int idx_src = y * width + x;
    const float value = mask[hook(0, idx_src)];
    if (value) {
      const int idx_dest = (y + offset_y) * width + x;
      dest[hook(1, idx_dest)] = value;
    }
  }
}