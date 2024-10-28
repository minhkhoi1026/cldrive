//{"A":0,"V":1,"col_start":3,"row_start":2,"size":4,"stride":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void copy_row(global float* A, global float* V, unsigned int row_start, unsigned int col_start, unsigned int size, unsigned int stride) {
  unsigned int glb_id = get_global_id(0);
  unsigned int glb_sz = get_global_size(0);

  for (unsigned int i = col_start + glb_id; i < size; i += glb_sz) {
    V[hook(1, i - col_start)] = A[hook(0, row_start * stride + i)];
  }
}