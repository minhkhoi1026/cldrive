//{"M":2,"ncol":1,"nrow":0,"out":4,"v":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_dgmm_left(const int nrow, const int ncol, global const float* M, global const float* v, global float* out) {
  const unsigned int gidx = get_global_id(0);

  unsigned int offset = gidx * ncol;
  for (unsigned int i = 0; i < ncol; i++) {
    out[hook(4, offset + i)] = M[hook(2, offset + i)] * v[hook(3, i)];
  }
}