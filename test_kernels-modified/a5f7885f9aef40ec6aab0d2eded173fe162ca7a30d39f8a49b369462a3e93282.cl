//{"buf":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compute(global int* buf, int size) {
  for (int i = 0; i < size; ++i)
    buf[hook(0, i)] += 1;
}