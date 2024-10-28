//{"out":2,"s":0,"s2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_signed_short(short s, short4 s2, global short* out) {
  *out = s;
  vstore4(s2, 4, out);
}