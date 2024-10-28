//{"cols":3,"rgb":0,"rgba":1,"rows":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rgb2rgba(global uchar* rgb, global float4* rgba, unsigned int rows, unsigned int cols) {
  unsigned int column = get_global_id(0);
  unsigned int row = get_global_id(1);

  unsigned int idx = row * cols + column;

  uchar3 pixel = vload3(idx, rgb);

  if (row < rows && column < cols) {
    rgba[hook(1, idx)] = (float4)(convert_float3(pixel) / 255.f, 1.f);
  }
}