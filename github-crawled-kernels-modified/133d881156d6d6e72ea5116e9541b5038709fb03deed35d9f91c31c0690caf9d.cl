//{"N":2,"flag":4,"h":1,"input":0,"output":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void correlate_sep2d_float(read_only image2d_t input, global float* h, const int N, write_only image2d_t output, const int flag) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i0 = get_global_id(0);
  unsigned int j0 = get_global_id(1);

  const int dx = flag & 1;
  const int dy = (flag & 2) / 2;

  float res = 0.f;

  for (int i = 0; i < N; ++i) {
    float j = i - .5f * (N - 1);
    res += h[hook(1, i)] * read_imagef(input, sampler, (float2)(i0 + dx * j, j0 + dy * j)).x;
  }

  write_imagef(output, (int2)(i0, j0), (float4)(res, 0, 0, 0));
}