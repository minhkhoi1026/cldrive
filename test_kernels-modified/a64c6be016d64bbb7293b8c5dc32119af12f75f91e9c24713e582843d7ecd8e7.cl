//{"coordinates":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void map_coordinates2(read_only image2d_t input, global float* output, global float* coordinates) {
  const sampler_t sampler = 0 | 4 | 0x20;

  unsigned int i = get_global_id(0);
  unsigned int N = get_global_size(0);

  float y = coordinates[hook(2, i)];
  float x = coordinates[hook(2, N + i)];

  y += .5f;
  x += .5f;

  float pix = read_imagef(input, sampler, (float2)(x, y)).x;

  output[hook(1, i)] = pix;
}