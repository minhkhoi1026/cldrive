//{"dst":0,"radv":2,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void avgblur_vert(write_only image2d_t dst, read_only image2d_t src, int radv) {
  const sampler_t sampler = (0 | 0x10);
  int2 loc = (int2)(get_global_id(0), get_global_id(1));
  int2 size = (int2)(get_global_size(0), get_global_size(1));

  int count = 0;
  float4 acc = (float4)(0, 0, 0, 0);

  for (int yy = max(0, loc.y - radv); yy < min(loc.y + radv + 1, size.y); yy++) {
    count++;
    acc += read_imagef(src, sampler, (int2)(loc.x, yy));
  }

  write_imagef(dst, loc, acc / count);
}