//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
ulong func_1(ulong* p_1) {
  return 1;
}

kernel void null_argument(global ulong* output) {
  *output = func_1((void*)0);
}