//{"arg_r":0,"coord_r":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t imageSampler = 0 | 4 | 0x10;
const sampler_t imageSampler2 = 0 | 2 | 0x10;
kernel void operation_gradient_magnitude(read_only image2d_t arg_r, write_only image2d_t out) {
  const unsigned int X = get_global_id(0);
  const unsigned int Y = get_global_id(1);

  int2 coord_w;
  coord_w.x = X;
  coord_w.y = Y;

  float2 coord_r[5];
  coord_r[hook(2, 0)].x = (float)X + 0.5f;
  coord_r[hook(2, 0)].y = (float)Y + 0.5f;
  coord_r[hook(2, 1)].x = coord_r[hook(2, 0)].x + 1;
  coord_r[hook(2, 1)].y = coord_r[hook(2, 0)].y;
  coord_r[hook(2, 2)].x = coord_r[hook(2, 0)].x - 1;
  coord_r[hook(2, 2)].y = coord_r[hook(2, 0)].y;
  coord_r[hook(2, 3)].x = coord_r[hook(2, 0)].x;
  coord_r[hook(2, 3)].y = coord_r[hook(2, 0)].y + 1;
  coord_r[hook(2, 4)].x = coord_r[hook(2, 0)].x;
  coord_r[hook(2, 4)].y = coord_r[hook(2, 0)].y - 1;

  float cell_value = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 0)]).s0;
  float d1 = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 1)]).s0 - cell_value;
  float d2 = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 2)]).s0 - cell_value;
  float d3 = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 3)]).s0 - cell_value;
  float d4 = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 4)]).s0 - cell_value;

  float value = sqrt((pow(d1, 2) + pow(d2, 2) + pow(d3, 2) + pow(d4, 2)) / 2.0f);
  write_imagef(out, coord_w, value);
}