//{"Awrk":5,"Bwrk":4,"N":0,"a":2,"b":3,"c":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void myMatrixMulti(const int N, global float* c, global float* a, global float* b, local float* Bwrk) {
  int j, k;
  int i = get_global_id(0);
  int iloc = get_local_id(0);
  int nloc = get_local_size(0);
  float tmp = 0.0f;
  float Awrk[1024];
  for (k = 0; k < N; ++k) {
    Awrk[hook(5, k)] = a[hook(2, i * N + k)];
  }
  for (j = 0; j < N; ++j) {
    for (k = iloc; k < N; k += nloc)
      Bwrk[hook(4, k)] = b[hook(3, k * N + j)];
    barrier(0x01);
    for (k = 0; k < N; k++)
      tmp += Awrk[hook(5, k)] * Bwrk[hook(4, k)];

    c[hook(1, i * N + j)] = tmp;

    barrier(0x01);
  }
}