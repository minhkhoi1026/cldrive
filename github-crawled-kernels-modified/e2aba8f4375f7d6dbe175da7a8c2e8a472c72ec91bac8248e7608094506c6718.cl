//{"local_size":1,"p":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void local_test(local char* p, int local_size) {
  for (int i = 0; i < local_size; i++) {
    p[hook(0, i)] = i;
  }
}