//{"m":1,"n":2,"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void __attribute__((reqd_work_group_size(1, 1, 1))) foo(global int* out, int m, int n) {
  bool a = m < 100;
  bool b = n > 50;
  if (a || b) {
    *out = 1;
  }
}