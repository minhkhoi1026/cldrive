//{"col":1,"data":0,"row":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
struct clComplex {
  double r;
  double i;
};
kernel void julia(global uchar* data, int col, int row) {
  int idx = get_global_id(0);
  int idy = get_global_id(1);
  if (idx < 3 && idx < 3) {
    size_t offset = idy + idx * 3;
    const double scalex = 1.500;
    const double scaley = 1.500;
    double jx = scalex * (double)(3 / 2 - idx) / (3 / 2);
    double jy = scaley * (double)(3 / 2 - idy) / (3 / 2);
    int juliaValue;
    struct clComplex c;
    c.r = -0.8;
    c.i = 0.156;
    struct clComplex a;
    struct clComplex b;
    a.r = jx;
    a.i = jy;
    int i;
    for (i = 0; i < 200; i++) {
      b.r = a.r;
      b.i = a.i;
      a.r = b.r * b.r - b.i * b.i + c.r;
      a.i = b.i * b.r + b.r * b.i + c.i;
      if (a.r * a.r + a.i * a.i > 5000) {
        juliaValue = 1;
        break;
      } else
        juliaValue = 0;
    }
    data[hook(0, offset)] = 255 * juliaValue;
  }
}