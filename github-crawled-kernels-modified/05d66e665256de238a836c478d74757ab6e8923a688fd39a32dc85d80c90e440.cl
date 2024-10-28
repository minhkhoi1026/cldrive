//{"A":0,"B":1,"dst":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(long A, long B, global long* dst) {
  *dst = A >= B;
}