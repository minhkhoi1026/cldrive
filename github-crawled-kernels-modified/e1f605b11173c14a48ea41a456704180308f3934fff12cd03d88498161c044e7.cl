//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add_redundancy(global float* a) {
  float b = *a + 0.0;
  *a = b;
}