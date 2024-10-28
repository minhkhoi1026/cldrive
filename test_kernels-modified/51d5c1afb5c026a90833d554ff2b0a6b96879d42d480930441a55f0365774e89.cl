//{"A":0,"dst":4,"k":2,"n":1,"src":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) bitcast_used_twice(global float* A, int n, int k) {
  float dst[25];
  float src[20];
  for (int i = 0; i < 20; i++) {
    src[hook(3, i)] = A[hook(0, i)];
  }
  for (int i = 0; i < 20; i++) {
    dst[hook(4, n + i)] = A[hook(0, i)];
  }
  A[hook(0, n)] = dst[hook(4, k)] + src[hook(3, k)];
}