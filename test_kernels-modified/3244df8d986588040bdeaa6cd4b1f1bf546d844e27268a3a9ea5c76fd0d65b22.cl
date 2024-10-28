//{"block":0,"factor":6,"ldy":4,"ldz":5,"nx":1,"ny":2,"nz":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fblock_opencl(global int* block, int nx, int ny, int nz, unsigned ldy, unsigned ldz, int factor) {
  int i, j, k;
  for (k = 0; k < nz; k++) {
    for (j = 0; j < ny; j++) {
      for (i = 0; i < nx; i++)
        block[hook(0, (k * ldz) + (j * ldy) + i)] = factor;
    }
  }
}