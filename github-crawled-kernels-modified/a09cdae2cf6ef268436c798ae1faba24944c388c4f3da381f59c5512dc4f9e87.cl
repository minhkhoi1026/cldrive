//{"input":0,"mat":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affine(read_only image3d_t input, global float* output, constant float* mat) {
  const sampler_t sampler = 0 | 2 | 0x20;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int k = get_global_id(2);

  unsigned int Nx = get_global_size(0);
  unsigned int Ny = get_global_size(1);
  unsigned int Nz = get_global_size(2);

  float x = (mat[hook(2, 0)] * i + mat[hook(2, 1)] * j + mat[hook(2, 2)] * k + mat[hook(2, 3)]);
  float y = (mat[hook(2, 4)] * i + mat[hook(2, 5)] * j + mat[hook(2, 6)] * k + mat[hook(2, 7)]);
  float z = (mat[hook(2, 8)] * i + mat[hook(2, 9)] * j + mat[hook(2, 10)] * k + mat[hook(2, 11)]);

  float pix = read_imagef(input, sampler, (float4)(x, y, z, 0)).x;

  output[hook(1, i + Nx * j + Nx * Ny * k)] = pix;
}