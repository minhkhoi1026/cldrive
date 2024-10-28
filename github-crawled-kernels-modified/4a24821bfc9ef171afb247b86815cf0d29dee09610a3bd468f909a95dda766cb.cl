//{"bitsum":0,"length":4,"log_stride":3,"n":1,"start":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global int* bitsum, int n, int start, int log_stride, int length) {
  int i = (get_global_id(0) << log_stride) + start;
  int j = i + length;

  if (j < n)
    bitsum[hook(0, j)] += bitsum[hook(0, i)];
}