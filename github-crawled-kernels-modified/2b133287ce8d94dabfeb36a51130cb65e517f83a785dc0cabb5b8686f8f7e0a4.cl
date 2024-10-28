//{"ALPHA":1,"INCX":3,"N":0,"X":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void const_kernel(int N, float ALPHA, global float* X, int INCX) {
  int i = get_global_id(2) * get_global_size(0) * get_global_size(1) + get_global_id(1) * get_global_size(0) + get_global_id(0);
  if (i < N)
    X[hook(2, i * INCX)] = ALPHA;
}