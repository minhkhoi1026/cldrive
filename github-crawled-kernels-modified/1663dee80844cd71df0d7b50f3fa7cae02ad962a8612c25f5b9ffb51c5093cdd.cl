//{"dest":1,"dims":5,"dual":0,"epsilon":4,"g":2,"step":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant sampler_t image_sampler = 0 | 2 | 0x10;
constant float2 zero2 = (float2)(0.0f, 0.0f);
kernel void gradient(global float2* dual, global float* dest, read_only image2d_t g, float step, float epsilon, int2 dims) {
  int2 coord = (int2)(get_global_id(0), get_global_id(1));
  int index = mad24(coord.y, dims.x, coord.x);

  float intensity = dest[hook(1, index)];

  float2 vec = dual[hook(0, index)];

  float gij = read_imagef(g, image_sampler, coord).x;
  float stepsilon = 1.0f + step * epsilon;
  vec.x = (vec.x + step * gij * (dest[hook(1, index + 1)] - intensity)) / stepsilon;
  vec.y = (vec.y + step * gij * (dest[hook(1, mad24(coord.y + 1, dims.x, coord.x))] - intensity)) / stepsilon;

  float mag = vec.x * vec.x + vec.y * vec.y;
  vec = mag > 1.0f ? vec / mag : vec;

  dual[hook(0, index)] = vec;
}