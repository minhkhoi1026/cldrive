//{"input":0,"mat":2,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void affine3(read_only image3d_t input, global float* output, constant float* mat) {
  const sampler_t sampler = 4 | 0x20;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int k = get_global_id(2);

  unsigned int Nx = get_global_size(0);
  unsigned int Ny = get_global_size(1);
  unsigned int Nz = get_global_size(2);

  float x = i;
  float y = j;
  float z = k;

  float x2 = (mat[hook(2, 8)] * z + mat[hook(2, 9)] * y + mat[hook(2, 10)] * x + mat[hook(2, 11)]);
  float y2 = (mat[hook(2, 4)] * z + mat[hook(2, 5)] * y + mat[hook(2, 6)] * x + mat[hook(2, 7)]);
  float z2 = (mat[hook(2, 0)] * z + mat[hook(2, 1)] * y + mat[hook(2, 2)] * x + mat[hook(2, 3)]);

  x2 += 0.5f;
  y2 += 0.5f;
  z2 += 0.5f;

  float4 coord_norm = (float4)(x2, y2, z2, 0.f);

  float pix = read_imagef(input, sampler, coord_norm).x;

  output[hook(1, i + Nx * j + Nx * Ny * k)] = pix;
}