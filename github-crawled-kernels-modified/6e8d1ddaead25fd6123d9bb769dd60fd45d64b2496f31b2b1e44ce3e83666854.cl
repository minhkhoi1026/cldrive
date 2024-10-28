//{"Nx":2,"Ny":3,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image2d_t input, write_only image2d_t output, const int Nx, const int Ny) {
  const sampler_t sampler = 0 | 0 | 0x10;

  int2 pos = (int2)(get_global_id(0), get_global_id(1));
  uint4 outPix = (uint4)(1, 0, 0, 0);

  int N = 3;
  float res = 0.f;
  float weightSum = 0.f;

  for (int i = -N; i <= N; i++) {
    for (int j = -N; j <= N; j++) {
      int2 pos1 = (int2)(pos.x + i, pos.y + j);
      uint4 pix1 = read_imageui(input, sampler, pos1);
      float weight = exp(-1.f * (i * i + j * j));
      res += weight * pix1.x;
      weightSum += weight;
    }
  }
  outPix.x = (unsigned int)(res / weightSum);
  write_imageui(output, pos, outPix);
}