//{"ALPHA":1,"INCX":3,"N":0,"X":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void scal_kernel(int N, float ALPHA, global float* X, int INCX) {
  size_t global_x = get_global_id(0);
  size_t global_y = get_global_id(1);
  size_t global_z = get_global_id(2);
  size_t i = global_z * get_global_size(0) * get_global_size(1) + global_y * get_global_size(0) + global_x;
  if (i < N)
    X[hook(2, i * INCX)] *= ALPHA;
}