//{"center":3,"cossin":4,"pixels":2,"sampler":5,"sinoline":1,"slice":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void ct_line(global float* slice, read_only image2d_t sinoline, int pixels, float center, float2 cossin, sampler_t sampler) {
  const int index = get_global_id(0);
  const int j = index / pixels;
  const int i = index % pixels;
  const int hp = pixels / 2;

  if ((i - hp) * (i - hp) + (j - hp) * (j - hp) < hp * hp - 1) {
    const float offsetI = center + (1 - cossin.y - cossin.x) * hp + cossin.y * j + cossin.x * i;
    slice[hook(0, index)] += read_imagef(sinoline, sampler, (float2)(offsetI, 0)).x;
  }
}