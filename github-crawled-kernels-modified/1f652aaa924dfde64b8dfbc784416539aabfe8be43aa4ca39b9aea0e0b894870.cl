//{"input":0,"output":1,"p":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void kernel_demosaic(read_only image2d_t input, write_only image2d_t output) {
  int x = 2 * get_global_id(0);
  int y = 2 * get_global_id(1);

  sampler_t sampler = 0 | 2 | 0x10;

  int x0 = x - 1;
  int y0 = y - 1;
  float4 p[16];

  for (int i = 0; i < 16; ++i) {
    p[hook(2, i)] = read_imagef(input, sampler, (int2)(x0 + i % 4, y0 + i / 4));
  }

  float4 p00, p01, p10, p11;
  p00.x = (p[hook(2, 4)].x + p[hook(2, 6)].x) / 2.0;
  p00.y = (p[hook(2, 5)].x * 4 + p[hook(2, 0)].x + p[hook(2, 2)].x + p[hook(2, 8)].x + p[hook(2, 10)].x) / 8.0;
  p00.z = (p[hook(2, 1)].x + p[hook(2, 9)].x) / 2.0;
  p01.x = p[hook(2, 6)].x;
  p01.y = (p[hook(2, 2)].x + p[hook(2, 5)].x + p[hook(2, 7)].x + p[hook(2, 10)].x) / 4.0;
  p01.z = (p[hook(2, 1)].x + p[hook(2, 3)].x + p[hook(2, 9)].x + p[hook(2, 11)].x) / 4.0;
  p10.x = (p[hook(2, 4)].x + p[hook(2, 6)].x + p[hook(2, 12)].x + p[hook(2, 14)].x) / 4.0;
  p10.y = (p[hook(2, 5)].x + p[hook(2, 8)].x + p[hook(2, 10)].x + p[hook(2, 13)].x) / 4.0;
  p10.z = p[hook(2, 9)].x;
  p11.x = (p[hook(2, 6)].x + p[hook(2, 14)].x) / 2.0;
  p11.y = (p[hook(2, 10)].x * 4 + p[hook(2, 5)].x + p[hook(2, 7)].x + p[hook(2, 13)].x + p[hook(2, 15)].x) / 8.0;
  p11.z = (p[hook(2, 9)].x + p[hook(2, 11)].x) / 2.0;

  write_imagef(output, (int2)(x, y), p00);
  write_imagef(output, (int2)(x + 1, y), p01);
  write_imagef(output, (int2)(x, y + 1), p10);
  write_imagef(output, (int2)(x + 1, y + 1), p11);
}