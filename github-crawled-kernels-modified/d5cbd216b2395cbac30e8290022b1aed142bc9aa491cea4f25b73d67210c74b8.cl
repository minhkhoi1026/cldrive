//{"target":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t sampler = 1 | 4 | 0x20;
kernel void red(write_only image2d_t target) {
  int x = get_global_id(0);
  int y = get_global_id(1);

  float4 red = (float4)(1.0f, 0.0f, 0.0f, 1.0f);

  if (x > 200 && x < 400 && y > 100 && y < 300) {
    write_imagef(target, (int2)(x, y), red);
  }
}