//{"aa":1,"b":2,"c":3,"n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matvecmult_kern(unsigned int n, global float* aa, global float* b, global float* c) {
  int i = get_global_id(0);
  int j;
  float tmp = 0.0f;
  for (j = 0; j < n; j++)
    tmp += aa[hook(1, i * n + j)] * b[hook(2, j)];
  barrier(0x01);
  c[hook(3, i)] = tmp;
}