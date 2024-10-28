//{"BSIZE":6,"FSIZE":5,"Nx":3,"Ny":4,"SIGMA":7,"input":0,"output":2,"projects":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void nlm2dProject(read_only image2d_t input, read_only image2d_t projects, global short* output, const int Nx, const int Ny, const int FSIZE, const int BSIZE, const float SIGMA) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);

  unsigned int pix0 = read_imageui(input, sampler, (int2)(i, j)).x;

  float res = 0;
  float sum = 0;

  float foo;

  unsigned int pix1;
  unsigned int p0, p1;

  float4 proj0 = read_imagef(projects, sampler, (int2)(i, j));

  for (int i1 = -BSIZE; i1 <= BSIZE; i1++) {
    for (int j1 = -BSIZE; j1 <= BSIZE; j1++) {
      float weight = 0;
      float dist = 0;

      float4 proj1 = read_imagef(projects, sampler, (int2)(i + i1, j + j1));

      pix1 = read_imageui(input, sampler, (int2)(i + i1, j + j1)).x;

      dist = length(proj0 - proj1) * (2.f * FSIZE + 1);
      weight = exp(-1.f / SIGMA / SIGMA * dist * dist);

      res += 1.f * pix1 * weight;
      sum += weight;
    }
  }
  output[hook(2, i + j * Nx)] = (short)(res / sum);
}