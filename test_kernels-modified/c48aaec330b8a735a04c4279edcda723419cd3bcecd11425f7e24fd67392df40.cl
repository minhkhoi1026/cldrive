//{"block":0,"err":7,"factor":6,"ldy":4,"ldz":5,"nx":1,"ny":2,"nz":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void block_opencl(global int* block, int nx, int ny, int nz, int ldy, int ldz, int factor, global int* err) {
  const int id = get_global_id(0);
  if (id > 0)
    return;

  unsigned int i, j, k;
  int val = 0;
  for (k = 0; k < nz; k++) {
    for (j = 0; j < ny; j++) {
      for (i = 0; i < nx; i++) {
        if (block[hook(0, (k * ldz) + (j * ldy) + i)] != factor * val) {
          *err = 1;
          return;
        } else {
          block[hook(0, (k * ldz) + (j * ldy) + i)] *= -1;
          val++;
        }
      }
    }
  }
}