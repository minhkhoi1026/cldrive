//{"val":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void hello(global ulong* val) {
  size_t i = get_global_id(0);
  for (ulong j = 0; j < 100000000; j++) {
    val[hook(0, i)] += j;
  }
}