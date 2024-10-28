//{"A":1,"B":2,"C":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_uchar(global uchar* C, global uchar* A, global uchar* B) {
  int id = get_global_id(0);
  C[hook(0, id)] = sub_sat(A[hook(1, id)], B[hook(2, id)]);
}