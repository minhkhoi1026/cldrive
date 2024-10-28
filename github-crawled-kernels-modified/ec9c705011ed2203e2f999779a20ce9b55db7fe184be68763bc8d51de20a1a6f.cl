//{"N":2,"bar":1,"dst":4,"foo":0,"src":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void jacobi(global void* foo, global void* bar, ulong N, global double* src, global double* dst) {
  ulong i = get_global_id(0) + 1;
  ulong j = get_global_id(1) + 1;

  if (i >= N - 1 || j >= N - 1) {
    return;
  }

  double u = src[hook(3, (i - 1) * N + j)];
  double d = src[hook(3, (i + 1) * N + j)];
  double l = src[hook(3, (i) * N + (j - 1))];
  double r = src[hook(3, (i) * N + (j + 1))];

  dst[hook(4, i * N + j)] = (u + d + l + r) / 4.0;
}