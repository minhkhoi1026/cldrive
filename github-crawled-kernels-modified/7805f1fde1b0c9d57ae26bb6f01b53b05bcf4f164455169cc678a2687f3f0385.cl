//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct S0 {
  int d;
  long b;
} fn1() {
  struct S0 a = {3};
  a.d;
  return a;
}
kernel void entry() {
  fn1();
}