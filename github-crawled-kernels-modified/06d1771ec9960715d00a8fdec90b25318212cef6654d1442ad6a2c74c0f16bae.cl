//{"p":1,"sum":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void sum(global float* sum, const global float* p) {
  const unsigned int GID = get_global_id(0);
  const unsigned int GSIZE = get_global_size(0);

  if (GID == 0) {
    sum[hook(0, 0)] = 0;
    for (size_t i = 0; i < GSIZE - 1; i++)
      sum[hook(0, 0)] += p[hook(1, i)];
  }
}