//{"amount":4,"coef_x":5,"coef_y":6,"dst":0,"horiz":10,"size_x":2,"size_y":3,"src":1,"tmp":8,"tmp[pos.y + 16 * y]":7,"tmp[pos.y + 8 + y - rad_y]":12,"tmp[pos.y + 8]":9,"tmp[pos.y + y * 16]":11}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void unsharp_local(write_only image2d_t dst, read_only image2d_t src, int size_x, int size_y, float amount, constant float* coef_x, constant float* coef_y) {
  const sampler_t sampler = (0 | 2 | 0x10);
  int2 block = (int2)(get_group_id(0), get_group_id(1)) * 16;
  int2 pos = (int2)(get_local_id(0), get_local_id(1));

  local float4 tmp[32][32];

  int rad_x = size_x / 2;
  int rad_y = size_y / 2;
  int x, y;

  for (y = 0; y <= 1; y++) {
    for (x = 0; x <= 1; x++) {
      tmp[hook(8, pos.y + 16 * y)][hook(7, pos.x + 16 * x)] = read_imagef(src, sampler, block + pos + (int2)(16 * x - 8, 16 * y - 8));
    }
  }

  barrier(0x01);

  float4 val = tmp[hook(8, pos.y + 8)][hook(9, pos.x + 8)];

  float4 horiz[2];
  for (y = 0; y <= 1; y++) {
    horiz[hook(10, y)] = 0.0f;
    for (x = 0; x < size_x; x++)
      horiz[hook(10, y)] += coef_x[hook(5, x)] * tmp[hook(8, pos.y + y * 16)][hook(11, pos.x + 8 + x - rad_x)];
  }

  barrier(0x01);

  for (y = 0; y <= 1; y++) {
    tmp[hook(8, pos.y + y * 16)][hook(11, pos.x + 8)] = horiz[hook(10, y)];
  }

  barrier(0x01);

  float4 sum = 0.0f;
  for (y = 0; y < size_y; y++)
    sum += coef_y[hook(6, y)] * tmp[hook(8, pos.y + 8 + y - rad_y)][hook(12, pos.x + 8)];

  if (block.x + pos.x < get_image_width(dst) && block.y + pos.y < get_image_height(dst))
    write_imagef(dst, block + pos, val + (val - sum) * amount);
}