//{"height":2,"iter":3,"output":0,"width":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 0x10;
kernel void mandelbrot(write_only image2d_t output, float width, float height, int iter) {
  size_t x = get_global_id(0);
  size_t y = get_global_id(1);

  float2 z, c;

  c.x = (float)width / (float)height * ((float)x / width - 0.5) * 2.2 - 0.7;
  c.y = ((float)y / height - 0.5) * 2.2 - 0.0;

  int i;
  z = c;
  for (i = 0; i < iter; i++) {
    float x = (z.x * z.x - z.y * z.y) + c.x;
    float y = (z.y * z.x + z.x * z.y) + c.y;

    if ((x * x + y * y) > 4.0)
      break;
    z.x = x;
    z.y = y;
  }

  float p = (float)i / (float)iter;
  float so = sin(p * 3.141592653) * 255.0;
  float co = (1 - cos(p * 3.141592653)) * 255.0;

  write_imageui(output, (int2)(x, y), (uint4)((unsigned int)co, co, (unsigned int)(co + so), 255));
}