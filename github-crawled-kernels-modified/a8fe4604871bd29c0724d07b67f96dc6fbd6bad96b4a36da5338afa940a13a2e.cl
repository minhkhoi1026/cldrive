//{"dest":1,"height_with":3,"height_without":4,"offset_y":5,"src":0,"value":6,"width":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float get(global float* src, int width, int height, int x, int y, float default_value) {
  if (0 <= x && x < width && 0 <= y && y < height) {
    return src[hook(0, y * width + x)];
  } else {
    return default_value;
  }
}

kernel void stencil(global float* src, global float* dest, int width, int height_with, int height_without, const int offset_y, const float value) {
  const int x = get_global_id(0);
  int y = get_global_id(1);
  if (x < width && y < height_without) {
    y += offset_y;
    const int idx = y * width + x;
    const float c = src[hook(0, idx)];
    const float l = get(src, width, height_with, x - 1, y, c);
    const float r = get(src, width, height_with, x + 1, y, c);
    const float t = get(src, width, height_with, x, y - 1, c);
    const float b = get(src, width, height_with, x, y + 1, c);
    dest[hook(1, idx)] = c + value * (t + b + l + r - 4 * c);
    ;
  }
}