//{"g_im":1,"g_re":0,"g_res":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
double cmp_abs_sq(double re, double im) {
  return re * re + im * im;
}

kernel void mandelbrot(global const double* g_re, global const double* g_im, global double* g_res) {
  double z_re = 0.0;
  double z_im = 0.0;
  int i;

  double log_zn, nu;

  global const double *re, *im;
  global double* res;

  int gid = get_global_id(0);
  re = &(g_re[hook(0, gid)]);
  im = &(g_im[hook(1, gid)]);
  res = &(g_res[hook(2, gid)]);

  for (i = 0; i < 100 && cmp_abs_sq(z_re, z_im) < 4.0; ++i) {
    double z_re_tmp = z_re * z_re - z_im * z_im + *re;
    z_im = 2 * z_re * z_im + *im;
    z_re = z_re_tmp;
  }

  if (i < 100) {
    log_zn = log(cmp_abs_sq(z_re, z_im)) / 2.0;
    nu = log(log_zn / log(2.0)) / log(2.0);
  } else {
    nu = 1.0;
  }

  *res = (double)i + 1.0 - nu;
}