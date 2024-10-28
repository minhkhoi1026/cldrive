//{"block":0,"factor":7,"ldy":5,"ldz":6,"nx":2,"ny":3,"nz":4,"offset":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fblock_opencl(global int* block, unsigned offset, int nx, int ny, int nz, unsigned ldy, unsigned ldz, int factor) {
  int i, j, k;
  block = (global void*)block + offset;
  for (k = 0; k < nz; k++) {
    for (j = 0; j < ny; j++) {
      for (i = 0; i < nx; i++)
        block[hook(0, (k * ldz) + (j * ldy) + i)] = factor;
    }
  }
}