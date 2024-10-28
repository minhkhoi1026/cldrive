//{"cols":3,"in":0,"out":1,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normalizeRGB(global float4* in, global float4* out, unsigned int rows, unsigned int cols) {
  unsigned int column = get_global_id(0);
  unsigned int row = get_global_id(1);

  unsigned int idx = row * cols + column;

  float4 pixel = in[hook(0, idx)];
  float sum = pixel.x + pixel.y + pixel.z;

  if (row < rows && column < cols) {
    pixel /= sum;
    pixel.w = 1.f;
    out[hook(1, idx)] = pixel;
  }
}