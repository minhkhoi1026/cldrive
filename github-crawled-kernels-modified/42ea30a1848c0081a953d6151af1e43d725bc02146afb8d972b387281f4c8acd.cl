//{"height":4,"in_half":0,"n":2,"out_half":1,"width":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float4 read(global const float* in_half, int x, int y, int w) {
  const int idx = x + w * y;
  return (float4)(vload_half(4 * idx + 0, in_half), vload_half(4 * idx + 1, in_half), vload_half(4 * idx + 2, in_half), vload_half(4 * idx + 3, in_half));
}

float weight(int i, int x, float invdx2) {
  return exp(-invdx2 * ((i - x) * (i - x)));
}

kernel void gaussian_blur_hor(global const float* in_half, global float* out_half, const int n, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int idx = x + width * y;

  if (x >= width || y >= height) {
    return;
  }

  float4 out = (float4)(0, 0, 0, 0);
  const float invdx2 = 1.0 / (width * width);
  float totWeight = 0;
  float w;
  for (int i = x - n; i <= x + n; ++i) {
    if (i >= 0 && i < width) {
      w = weight(i, x, invdx2);
      out += w * read(in_half, i, y, width);
      totWeight += w;
    }
  }
  out /= totWeight;

  vstore_half(out.x, 4 * idx + 0, out_half);
  vstore_half(out.y, 4 * idx + 1, out_half);
  vstore_half(out.z, 4 * idx + 2, out_half);
  vstore_half(out.w, 4 * idx + 3, out_half);
}