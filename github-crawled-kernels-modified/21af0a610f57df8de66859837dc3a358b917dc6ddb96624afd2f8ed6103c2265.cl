//{"Nx":2,"Ny":3,"Nz":4,"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void run(read_only image3d_t input, global short* output, const int Nx, const int Ny, const int Nz) {
  const sampler_t sampler = 0 | 2 | 0x10;

  int i = get_global_id(0);
  int j = get_global_id(1);

  float sum = 0;

  for (int k = 0; k < Nz; ++k)
    sum += read_imageui(input, sampler, (int4)(i, j, k, 0)).x;
  ;

  output[hook(1, i + j * Nx)] = (short)(sum / Nz);
}