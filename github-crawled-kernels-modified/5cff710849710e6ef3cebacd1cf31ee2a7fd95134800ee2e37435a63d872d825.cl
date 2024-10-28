//{"A":1,"B":2,"C":0,"alpha":6,"beta":7,"height1":3,"height2":4,"offset":9,"pitch":8,"width":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void oclkernel(global double* C, global const double* restrict const A, global const double* restrict const B, int height1, int height2, int width, double alpha, double beta, int pitch, ulong offset) {
  int i, j, k;
  for (i = get_global_id(1); i < height2; i += get_global_size(1)) {
    for (j = get_global_id(0); j < height1; j += get_global_size(0)) {
      double addval = 0.;
      for (k = 0; k < width; k++) {
        addval += A[hook(1, k * height2 + i)] * B[hook(2, k * height1 + j)];
      }
      C[hook(0, offset + i * pitch + j)] = beta * C[hook(0, offset + i * pitch + j)] + alpha * addval;
    }
  }
}