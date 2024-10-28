//{"in":0,"ncols":3,"nrows":2,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void array_copy(global float* in, global float* out, const int nrows, const int ncols) {
  int gid = get_global_id(0);
  for (int j = 0; j < ncols - 1; j++) {
    out[hook(1, gid * ncols + j)] = (float)(gid * ncols + j);
  }
}