//{"dest":1,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void img3d_to_buf_float(read_only image3d_t src, global float* dest) {
  const sampler_t sampler = 1 | 2 | 0x10;

  unsigned int i = get_global_id(0);
  unsigned int j = get_global_id(1);
  unsigned int k = get_global_id(2);

  unsigned int Nx = get_global_size(0);
  unsigned int Ny = get_global_size(1);
  unsigned int Nz = get_global_size(2);

  float4 val = read_imagef(src, sampler, (float4)(1.f * i / (Nx - 1.f), 1.f * j / (Ny - 1.f), 1.f * k / (Nz - 1.f), 0.f));
  dest[hook(1, i + Nx * j + Nx * Ny * k)] = val.x;
}