//{"center":4,"cossins":5,"pixels":2,"sampler":6,"sinogram":1,"slice":0,"thetas":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ct_sino(global float* slice, read_only image2d_t sinogram, int pixels, int thetas, float center, global const float2* cossins, sampler_t sampler) {
  const int index = get_global_id(0);
  const int j = index / pixels;
  const int i = index % pixels;
  const int hp = pixels / 2;

  if ((i - hp) * (i - hp) + (j - hp) * (j - hp) >= hp * hp - 1) {
    slice[hook(0, index)] = 0;
  } else {
    float total = 0.0f;
    for (size_t proj = 0; proj < thetas; proj++) {
      const float2 cossin = cossins[hook(5, proj)];
      float offsetI = center + (1 - cossin.x - cossin.y) * hp + cossin.x * j + cossin.y * i;
      total += read_imagef(sinogram, sampler, (float2)(offsetI, proj)).x;
    }
    slice[hook(0, index)] = total;
  }
}