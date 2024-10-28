//{"arg_r":0,"coord_r":2,"out":1,"part":4,"values":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t imageSampler = 0 | 4 | 0x10;
const sampler_t imageSampler2 = 0 | 2 | 0x10;
kernel void descent_grad(read_only image2d_t arg_r, write_only image2d_t out) {
  const unsigned int X = get_global_id(0);
  const unsigned int Y = get_global_id(1);

  int2 coord_w;
  coord_w.x = X;
  coord_w.y = Y;

  float2 coord_r[7];
  coord_r[hook(2, 0)].x = X;
  coord_r[hook(2, 0)].y = Y;
  coord_r[hook(2, 1)].x = coord_r[hook(2, 0)].x - 1;
  coord_r[hook(2, 1)].y = coord_r[hook(2, 0)].y;
  coord_r[hook(2, 2)].x = coord_r[hook(2, 0)].x;
  coord_r[hook(2, 2)].y = coord_r[hook(2, 0)].y - 1;
  coord_r[hook(2, 3)].x = coord_r[hook(2, 0)].x + 1;
  coord_r[hook(2, 3)].y = coord_r[hook(2, 0)].y;
  coord_r[hook(2, 4)].x = coord_r[hook(2, 0)].x;
  coord_r[hook(2, 4)].y = coord_r[hook(2, 0)].y + 1;
  coord_r[hook(2, 5)].x = coord_r[hook(2, 0)].x + 1;
  coord_r[hook(2, 5)].y = coord_r[hook(2, 0)].y - 1;
  coord_r[hook(2, 6)].x = coord_r[hook(2, 0)].x - 1;
  coord_r[hook(2, 6)].y = coord_r[hook(2, 0)].y + 1;

  float eps = 1E-8;
  float values[7];
  values[hook(3, 0)] = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 0)]).s0;
  values[hook(3, 1)] = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 1)]).s0;
  values[hook(3, 2)] = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 2)]).s0;
  values[hook(3, 3)] = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 3)]).s0;
  values[hook(3, 4)] = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 4)]).s0;
  values[hook(3, 5)] = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 5)]).s0;
  values[hook(3, 6)] = read_imagef(arg_r, imageSampler2, coord_r[hook(2, 6)]).s0;

  float t1, t2;
  float part[3];
  t1 = values[hook(3, 0)] - values[hook(3, 1)];
  t2 = values[hook(3, 0)] - values[hook(3, 2)];
  part[hook(4, 0)] = (t1 + t2) / sqrt(eps + pow(t1, 2) + pow(t2, 2));
  t1 = values[hook(3, 3)] - values[hook(3, 0)];
  t2 = values[hook(3, 3)] - values[hook(3, 5)];
  part[hook(4, 1)] = t1 / sqrt(eps + pow(t1, 2) + pow(t2, 2));
  t1 = values[hook(3, 4)] - values[hook(3, 0)];
  t2 = values[hook(3, 4)] - values[hook(3, 6)];
  part[hook(4, 2)] = t1 / sqrt(eps + pow(t1, 2) + pow(t2, 2));

  float value = part[hook(4, 0)] - part[hook(4, 1)] - part[hook(4, 2)];
  write_imagef(out, coord_w, value);
}