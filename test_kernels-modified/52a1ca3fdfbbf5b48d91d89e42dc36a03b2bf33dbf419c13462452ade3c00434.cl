//{"in":2,"ncol":1,"nrow":0,"out":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clkernel_sumrow(int nrow, int ncol, global const float* in, global float* out) {
  const int idx = get_global_id(0);
  if (idx >= nrow)
    return;

  float sum = 0.0f;
  for (int j = 0; j < ncol; j++) {
    sum += in[hook(2, j + ncol * idx)];
  }
  out[hook(3, idx)] = sum;
}