//{"a":0,"res":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testUToS(global uint2* a, global char2* res) {
  res[hook(1, 0)] = convert_char2_sat(*a);
}