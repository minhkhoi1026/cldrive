//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test() {
  volatile double a = 1.2;
  volatile double b = 100.0 / 33.0;
  volatile double c = -42.314;
  volatile double d = 314.42;
  volatile double e = 314e7;
  volatile double f = 314e-7;
}