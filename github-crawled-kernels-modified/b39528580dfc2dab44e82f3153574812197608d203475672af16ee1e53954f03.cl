//{"C":3,"maxiter":2,"scale":1,"xsize":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void vector_mandelbrot(const unsigned int xsize, const double scale, const unsigned int maxiter, global int* C) {
  int i = get_global_id(0);
  double cre = (i / xsize) * scale - 1.0;
  double cim = (i % xsize) * scale - 1.0;
  double re = cre;
  double im = cim;
  double retemp;
  int result = 0;

  for (unsigned int j = 0; j < maxiter; j++) {
    retemp = re;
    re = re * re - im * im + cre;
    im = 2 * retemp * im + cim;
    result += (re * re + im * im < 4);
  }
  C[hook(3, i)] = result;
}