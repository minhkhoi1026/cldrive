//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void rhadd_overflow(global ulong* output) {
  output[hook(0, 0)] = rhadd(0UL, 0xFFFFFFFFFFFFFFFFUL);
}