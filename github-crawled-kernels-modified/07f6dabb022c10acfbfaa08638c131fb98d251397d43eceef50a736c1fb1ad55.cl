//{"Nhx":4,"Nx":3,"h":1,"input":0,"output":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void convolve1d(read_only image2d_t input, global float* h, global float* output, const int Nx, const int Nhx) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i0 = get_global_id(0);

  float res = 0.f;

  for (int i = 0; i < Nhx; ++i) {
    float dx = -.5f * (Nhx - 1) + i;
    res += h[hook(1, i)] * read_imagef(input, sampler, (float2)(i0 + dx, 0)).x;
  }

  output[hook(2, i0)] = res;
}