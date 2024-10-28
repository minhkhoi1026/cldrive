//{"a":1,"ab":3,"b":2,"entries":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void addVectors(const int entries, global const float* a, global const float* b, global float* ab) {
  const int N = get_local_id(0) + (16 * get_group_id(0));

  if (N < entries) {
    ab[hook(3, N)] = a[hook(1, N)] + b[hook(2, N)];
  }
}