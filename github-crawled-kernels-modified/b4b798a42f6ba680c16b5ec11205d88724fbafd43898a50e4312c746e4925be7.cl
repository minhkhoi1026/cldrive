//{"inout":1,"n":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add32(const int n, global float* inout) {
  const int i = get_global_id(0);
  const int j = get_global_id(1);

  if ((i < n) && (j < n)) {
    inout[hook(1, i * n + j)] += 1.0f;
  }
}