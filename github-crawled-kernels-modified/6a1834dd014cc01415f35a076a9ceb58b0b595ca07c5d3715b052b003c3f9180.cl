//{"dest":1,"height":3,"src":0,"value":4,"width":2}
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

kernel void stencil(global float* src, global float* dest, int width, int height, const float value) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x < width && y < height) {
    const int idx = y * width + x;
    const float c = src[hook(0, idx)];
    const float l = get(src, width, height, x - 1, y, c);
    const float r = get(src, width, height, x + 1, y, c);
    const float t = get(src, width, height, x, y - 1, c);
    const float b = get(src, width, height, x, y + 1, c);
    dest[hook(1, idx)] = c + value * (t + b + l + r - 4 * c);
    ;
  }
}