//{"size":2,"tmp":1,"x":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void norm_l2_false_f(global float* x, global float* tmp, const unsigned int size) {
  unsigned int tid = get_global_id(0);
  unsigned int blocksize = get_local_size(0);

  const unsigned int iter = size / (get_global_size(0));
  unsigned int pos = tid;

  float temp = 0;

  for (unsigned long i = 0; i < iter; ++i) {
    temp += x[hook(0, pos)] * x[hook(0, pos)];
    pos += get_global_size(0);
  }

  if (pos < size) {
    temp += x[hook(0, pos)] * x[hook(0, pos)];
  }
  tmp[hook(1, tid)] = temp;
}