//{"Nx":4,"Ny":5,"Nz":6,"accBuf":2,"distImg":1,"dx":7,"dy":8,"dz":9,"input":0,"sigma":10,"weightBuf":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void computePlus(read_only image3d_t input, read_only image3d_t distImg, global float* accBuf, global float* weightBuf, const int Nx, const int Ny, const int Nz, const int dx, const int dy, const int dz, const float sigma) {
  const sampler_t sampler = 0 | 2 | 0x10;

  unsigned int i0 = get_global_id(0);
  unsigned int j0 = get_global_id(1);
  unsigned int k0 = get_global_id(2);

  unsigned int dist = read_imageui(distImg, sampler, (int4)(i0, j0, k0, 0)).x;

  unsigned int pix = read_imageui(input, sampler, (int4)(i0 + dx, j0 + dy, k0 + dz, 0)).x;

  float weight = exp(-1.f * dist / sigma / sigma);

  accBuf[hook(2, i0 + Nx * j0 + Nx * Ny * k0)] += (float)(weight * pix);
  weightBuf[hook(3, i0 + Nx * j0 + Nx * Ny * k0)] += (float)(weight);
}