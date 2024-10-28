//{}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
extern int test_function(void);
kernel void test_kernel() {
  int f = test_function();

  double v1 = 1.0000000000000002;
  int i;
  double z_x = 0, z_y = 0;
  double j_x, j_y;
  double c_x = 0.3695692, c_y = 0.27758014;
  double d;
  double tmp1;

  for (i = 0; i < 2500; i++) {
    tmp1 = z_y * z_y;

    j_x = mad(z_x, z_x, -tmp1);
    j_x += c_x;

    j_y = 2 * z_x * z_y + c_y;
    d = (j_x * j_x + j_y * j_y);
    if (d > 2)
      break;
    z_x = j_x;
    z_y = j_y;
  }
}