//{"in":2,"ncol":1,"nrow":0,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_rowmax(const unsigned int nrow, const unsigned int ncol, global const float* in, global float* out) {
  const unsigned int row_id = get_global_id(0);
  if (row_id >= nrow)
    return;

  float row_max_val = -0x1.fffffep127f;
  for (unsigned int i = 0; i < ncol; i++) {
    row_max_val = fmax(row_max_val, in[hook(2, row_id * ncol + i)]);
  }

  out[hook(3, row_id)] = row_max_val;
}