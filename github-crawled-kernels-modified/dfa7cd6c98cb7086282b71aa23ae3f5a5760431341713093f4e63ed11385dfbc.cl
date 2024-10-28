//{"Nx":1,"Ny":2,"Nz":3,"gaussKernel":5,"matrix":0,"result":6,"size":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
constant const sampler_t nearest_sampler = 0 | 2 | 0x10;
kernel void gaussY(global const float* matrix, const int Nx, const int Ny, const int Nz, const int size, global const float* gaussKernel, global float* result) {
  const int x = get_global_id(0);
  const int y = get_global_id(1);
  const int z = get_global_id(2);

  float value = 0;
  int yVar = 0;
  for (int i = 0; i < size; i++) {
    yVar = y + i - size / 2;
    if (yVar < 0 || yVar >= Ny)
      continue;
    value += matrix[hook(0, x + yVar * Nx + z * Nx * Ny)] * gaussKernel[hook(5, size - i - 1)];
  }
  result[hook(6, x + y * Nx + z * Nx * Ny)] = value;
}