//{"blurxx_h":0,"blurxy_h":1,"bluryy_h":2,"corner":3,"gmask":4,"radius":5,"threshold":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float gray(float4 v) {
  return 0.299f * v.x + 0.587f * v.y + 0.114f * v.z;
}

kernel void cornerness(read_only image2d_t blurxx_h, read_only image2d_t blurxy_h, read_only image2d_t bluryy_h, write_only image2d_t corner, constant float* gmask, int radius, float threshold) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float vxx = 0.0f;
  float vxy = 0.0f;
  float vyy = 0.0f;

  for (int r = -radius; r <= radius; r++) {
    vxx += gmask[hook(4, r + radius)] * read_imagef(blurxx_h, sampler, (int2)(x, y + r)).x;
    vxy += gmask[hook(4, r + radius)] * read_imagef(blurxy_h, sampler, (int2)(x, y + r)).x;
    vyy += gmask[hook(4, r + radius)] * read_imagef(bluryy_h, sampler, (int2)(x, y + r)).x;
  }

  float det = vxx * vyy - vxy * vxy;
  float trace = vxx + vyy;

  const float k = 0.04f;

  float response = det - k * (trace * trace);

  write_imagef(corner, (int2)(x, y), (response > threshold) ? (float4)(response) : (float4)(-0x1.fffffep127f));
}