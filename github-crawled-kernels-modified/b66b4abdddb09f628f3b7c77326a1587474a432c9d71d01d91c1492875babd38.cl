//{"input":0,"sobelx":1,"sobely":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float gray(float4 v) {
  return 0.299f * v.x + 0.587f * v.y + 0.114f * v.z;
}

kernel void sobel(read_only image2d_t input, write_only image2d_t sobelx, write_only image2d_t sobely) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float h = +1.0f * gray(read_imagef(input, sampler, (int2)(x - 1, y - 1))) - 1.0f * gray(read_imagef(input, sampler, (int2)(x + 1, y - 1))) + 2.0f * gray(read_imagef(input, sampler, (int2)(x - 1, y))) - 2.0f * gray(read_imagef(input, sampler, (int2)(x + 1, y))) + 1.0f * gray(read_imagef(input, sampler, (int2)(x - 1, y + 1))) - 1.0f * gray(read_imagef(input, sampler, (int2)(x + 1, y + 1)));

  float v = +1.0f * gray(read_imagef(input, sampler, (int2)(x - 1, y - 1))) + 2.0f * gray(read_imagef(input, sampler, (int2)(x, y - 1))) + 1.0f * gray(read_imagef(input, sampler, (int2)(x + 1, y - 1))) - 1.0f * gray(read_imagef(input, sampler, (int2)(x - 1, y + 1))) - 2.0f * gray(read_imagef(input, sampler, (int2)(x, y + 1))) - 1.0f * gray(read_imagef(input, sampler, (int2)(x + 1, y + 1)));

  write_imagef(sobelx, (int2)(x, y), h);
  write_imagef(sobely, (int2)(x, y), v);
}