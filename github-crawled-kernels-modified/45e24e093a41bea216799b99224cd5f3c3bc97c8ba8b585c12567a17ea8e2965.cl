//{"A":0,"size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void range_op(global float* A, const int size) {
  const unsigned range = size / get_global_size(0);
  const unsigned start = get_global_id(0) * range;
  const unsigned end = get_global_id(0) == get_global_size(0) ? size : start + range;
  for (int i = start; i < end; ++i) {
    A[hook(0, i)] = sqrt(A[hook(0, i)]);
  }
}