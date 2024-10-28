//{"Nx":4,"Ny":5,"accBuf":2,"distImg":1,"dx":6,"dy":7,"input":0,"sigma":8,"weightBuf":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computeMinus(read_only image2d_t input, read_only image2d_t distImg, global float* accBuf, global float* weightBuf, const int Nx, const int Ny, const int dx, const int dy, const float sigma) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i0 = get_global_id(0);
  unsigned int j0 = get_global_id(1);

  float dist = read_imagef(distImg, sampler, (int2)(i0 - dx, j0 - dy)).x;

  float pix = read_imagef(input, sampler, (int2)(i0 - dx, j0 - dy)).x;

  float Npatch = (2.f * 3 + 1.f) * (2.f * 3 + 1.f);

  float weight = exp(-1.f * dist / ((2 * 3 + 1) * (2 * 3 + 1)) / sigma / sigma);

  accBuf[hook(2, i0 + Nx * j0)] += (float)(weight * pix);
  weightBuf[hook(3, i0 + Nx * j0)] += (float)(weight);
}