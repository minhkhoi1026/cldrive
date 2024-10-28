//{"a":0,"b":1,"c":2,"res":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testBitOperations(int a, int b, int c, global int* res) {
  *res = (a & b) | (0x6F ^ c);
  *res += popcount(b);
}