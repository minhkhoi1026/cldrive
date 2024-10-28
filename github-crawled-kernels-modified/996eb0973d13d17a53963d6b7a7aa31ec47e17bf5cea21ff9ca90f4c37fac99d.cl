//{"flag":2,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve(read_only image2d_t input, write_only image2d_t output, const int flag) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i0 = get_global_id(0);
  unsigned int j0 = get_global_id(1);

  const int dx = flag & 1;
  const int dy = (flag & 2) / 2;

  float res = 0.f;

  for (int i = -3; i <= 3; ++i)
    res += read_imagef(input, sampler, (int2)(i0 + dx * i, j0 + dy * i)).x;

  write_imagef(output, (int2)(i0, j0), (float4)(res, 0, 0, 0));
}