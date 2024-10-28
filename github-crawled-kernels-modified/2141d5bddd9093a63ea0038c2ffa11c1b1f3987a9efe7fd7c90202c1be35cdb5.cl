//{"out":2,"u":0,"u2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_unsigned_short(ushort u, ushort4 u2, global ushort* out) {
  *out = u;
  vstore4(u2, 4, out);
}