//{"a":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void loop(global float* a) {
  for (int i = 0; i < 100; i++) {
    a[hook(0, i)] = i * 2;
  }
}