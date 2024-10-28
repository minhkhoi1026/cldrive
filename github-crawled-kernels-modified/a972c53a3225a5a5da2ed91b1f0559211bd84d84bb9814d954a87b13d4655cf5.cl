//{"dest":1,"height":3,"max_val":4,"src":0,"width":2}
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

inline uchar4 gray(const float percentage) {
  const unsigned char v = (unsigned char)(percentage * 255);
  return (uchar4)(v, v, v, 1);
}

kernel void map_gray(global float* src, global uchar4* dest, int width, int height, float max_val) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  if (x < width && y < height) {
    const int idx = y * width + x;
    const float v = src[hook(0, idx)];
    const float p = (v < max_val ? v : max_val) / max_val;
    dest[hook(1, idx)] = gray(p);
  }
}