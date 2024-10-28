//{"blurxx_h":2,"blurxy_h":3,"bluryy_h":4,"gmask":5,"radius":6,"sobelx":0,"sobely":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
const sampler_t sampler = 0 | 4 | 0x10;
float gray(float4 v) {
  return 0.299f * v.x + 0.587f * v.y + 0.114f * v.z;
}

kernel void blurx(read_only image2d_t sobelx, read_only image2d_t sobely, write_only image2d_t blurxx_h, write_only image2d_t blurxy_h, write_only image2d_t bluryy_h, constant float* gmask, int radius) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);

  float vxx = 0.0f;
  float vxy = 0.0f;
  float vyy = 0.0f;

  for (int r = -radius; r <= radius; r++) {
    float sx = read_imagef(sobelx, sampler, (int2)(x + r, y)).x;
    float sy = read_imagef(sobely, sampler, (int2)(x + r, y)).x;

    vxx += gmask[hook(5, r + radius)] * (sx * sx);
    vxy += gmask[hook(5, r + radius)] * (sx * sy);
    vyy += gmask[hook(5, r + radius)] * (sy * sy);
  }

  write_imagef(blurxx_h, (int2)(x, y), (float4)(vxx));
  write_imagef(blurxy_h, (int2)(x, y), (float4)(vxy));
  write_imagef(bluryy_h, (int2)(x, y), (float4)(vyy));
}