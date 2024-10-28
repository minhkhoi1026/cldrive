//{"arg_r":0,"coord_r":3,"magnitude":1,"magnitudes":5,"out":2,"values":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t imageSampler = 0 | 4 | 0x10;
const sampler_t imageSampler2 = 0 | 2 | 0x10;
kernel void operation_gradient_direction(read_only image2d_t arg_r, read_only image2d_t magnitude, write_only image2d_t out) {
  const unsigned int X = get_global_id(0);
  const unsigned int Y = get_global_id(1);

  int2 coord_w;
  coord_w.x = X;
  coord_w.y = Y;

  float2 coord_r[5];
  coord_r[hook(3, 0)].x = (float)X + 0.5f;
  coord_r[hook(3, 0)].y = (float)Y + 0.5f;
  coord_r[hook(3, 1)].x = coord_r[hook(3, 0)].x + 1;
  coord_r[hook(3, 1)].y = coord_r[hook(3, 0)].y;
  coord_r[hook(3, 2)].x = coord_r[hook(3, 0)].x - 1;
  coord_r[hook(3, 2)].y = coord_r[hook(3, 0)].y;
  coord_r[hook(3, 3)].x = coord_r[hook(3, 0)].x;
  coord_r[hook(3, 3)].y = coord_r[hook(3, 0)].y + 1;
  coord_r[hook(3, 4)].x = coord_r[hook(3, 0)].x;
  coord_r[hook(3, 4)].y = coord_r[hook(3, 0)].y - 1;

  float values[5];
  values[hook(4, 0)] = read_imagef(arg_r, imageSampler2, coord_r[hook(3, 0)]).s0;
  values[hook(4, 1)] = read_imagef(arg_r, imageSampler2, coord_r[hook(3, 1)]).s0;
  values[hook(4, 2)] = read_imagef(arg_r, imageSampler2, coord_r[hook(3, 2)]).s0;
  values[hook(4, 3)] = read_imagef(arg_r, imageSampler2, coord_r[hook(3, 3)]).s0;
  values[hook(4, 4)] = read_imagef(arg_r, imageSampler2, coord_r[hook(3, 4)]).s0;

  float magnitudes[5];
  magnitudes[hook(5, 0)] = read_imagef(magnitude, imageSampler2, coord_r[hook(3, 0)]).s0;
  magnitudes[hook(5, 1)] = read_imagef(magnitude, imageSampler2, coord_r[hook(3, 1)]).s0;
  magnitudes[hook(5, 2)] = read_imagef(magnitude, imageSampler2, coord_r[hook(3, 2)]).s0;
  magnitudes[hook(5, 3)] = read_imagef(magnitude, imageSampler2, coord_r[hook(3, 3)]).s0;
  magnitudes[hook(5, 4)] = read_imagef(magnitude, imageSampler2, coord_r[hook(3, 4)]).s0;

  float direction = 0;
  if (magnitudes[hook(5, 0)])
    direction += (4 * values[hook(4, 0)] - values[hook(4, 1)] - values[hook(4, 2)] - values[hook(4, 3)] - values[hook(4, 4)]) / magnitudes[hook(5, 0)];
  if (magnitudes[hook(5, 1)])
    direction += (values[hook(4, 0)] - values[hook(4, 1)]) / magnitudes[hook(5, 1)];
  if (magnitudes[hook(5, 2)])
    direction += (values[hook(4, 0)] - values[hook(4, 2)]) / magnitudes[hook(5, 2)];
  if (magnitudes[hook(5, 3)])
    direction += (values[hook(4, 0)] - values[hook(4, 3)]) / magnitudes[hook(5, 3)];
  if (magnitudes[hook(5, 4)])
    direction += (values[hook(4, 0)] - values[hook(4, 4)]) / magnitudes[hook(5, 4)];

  write_imagef(out, coord_w, direction);
}