//{"dst":0,"rad":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void avgblur_horiz(write_only image2d_t dst, read_only image2d_t src, int rad) {
  const sampler_t sampler = (0 | 0x10);
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  int2 size = (int2)(get_global_size(0), get_global_size(1));

  int count = 0;
  float4 acc = (float4)(0, 0, 0, 0);

  for (int xx = max(0, loc.x - rad); xx < min(loc.x + rad + 1, size.x); xx++) {
    count++;
    acc += read_imagef(src, sampler, (int2)(xx, loc.y));
  }

  write_imagef(dst, loc, acc / count);
}