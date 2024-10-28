//{"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_kernel(global ulong* output) {
  local char l_int8[3];
  local int l_int32[3];
  local float l_float[3];
  output[hook(0, 0)] = (ulong)l_int8;
  output[hook(0, 1)] = (ulong)l_int32;
  output[hook(0, 2)] = (ulong)l_float;
}