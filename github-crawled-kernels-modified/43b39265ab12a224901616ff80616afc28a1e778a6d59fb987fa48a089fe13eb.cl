//{"size":3,"tmp":2,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void dot_product_d(global double* x, global double* y, global double* tmp, const unsigned int size) {
  unsigned int tid = get_global_id(0);
  unsigned int blocksize = get_local_size(0);

  const unsigned int iter = size / (get_global_size(0));
  unsigned int pos = tid;

  double temp = 0;

  for (unsigned long i = 0; i < iter; ++i) {
    temp += x[hook(0, pos)] * y[hook(1, pos)];
    pos += get_global_size(0);
  }

  if (pos < size) {
    temp += x[hook(0, pos)] * y[hook(1, pos)];
  }
  tmp[hook(2, tid)] = temp;
}