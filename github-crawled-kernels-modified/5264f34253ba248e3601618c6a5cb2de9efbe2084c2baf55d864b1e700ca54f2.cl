//{"dst":2,"src0":0,"src1":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_read_image(read_only image2d_t src0, read_only image2d_t src1, global float4* dst) {
  float4 sum = 0;
  int2 coord;
  int x_sz = (int)get_global_size(0);
  int y_sz = (int)get_global_size(1);
  const sampler_t sampler = 0 | 4 | 0x10;
  int i, j;

  int x = (int)get_global_id(0);
  int y = (int)get_global_id(1);

  for (i = 0; i < 4; i++) {
    coord.x = x + i * x_sz;
    for (j = 0; j < 4; j++) {
      coord.y = y + j * y_sz;
      sum = sum + read_imagef(src0, sampler, coord) + read_imagef(src1, sampler, coord);
    }
  }
  dst[hook(2, y * x_sz + x)] = sum;
}