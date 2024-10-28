//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void A(global float* a) {
  int b = get_global_id(0);
  a[hook(0, b)] += 1.0f;
}