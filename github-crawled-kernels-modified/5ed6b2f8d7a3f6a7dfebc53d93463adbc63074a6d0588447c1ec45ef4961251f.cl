//{"a_half":0,"alpha":3,"b_half":1,"height":5,"out_half":2,"width":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lerp(global const float* a_half, global const float* b_half, global float* out_half, const float alpha, const int width, const int height) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  const int idx = x + width * y;

  if (x >= width || y >= height) {
    return;
  }

  const float4 a = (float4)(vload_half(4 * idx + 0, a_half), vload_half(4 * idx + 1, a_half), vload_half(4 * idx + 2, a_half), vload_half(4 * idx + 3, a_half));
  const float4 b = (float4)(vload_half(4 * idx + 0, b_half), vload_half(4 * idx + 1, b_half), vload_half(4 * idx + 2, b_half), vload_half(4 * idx + 3, b_half));

  float4 out = (1 - alpha) * a + alpha * b;

  vstore_half(out.x, 4 * idx + 0, out_half);
  vstore_half(out.y, 4 * idx + 1, out_half);
  vstore_half(out.z, 4 * idx + 2, out_half);
  vstore_half(out.w, 4 * idx + 3, out_half);
}