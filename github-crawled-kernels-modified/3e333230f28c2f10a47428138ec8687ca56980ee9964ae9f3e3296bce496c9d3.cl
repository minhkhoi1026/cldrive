//{"cImags":1,"cReals":0,"finalIterations":2,"maxIterations":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void iterate_points(constant const double* cReals, constant const double* cImags, global int* finalIterations, const int maxIterations) {
  int globalId = (int)get_global_id(0);

  double cReal = cReals[hook(0, globalId)];
  double cImag = cImags[hook(1, globalId)];

  double zReal = 0;
  double zImag = 0;

  double zReal2 = 0;
  double zImag2 = 0;

  int iterations = 0;

  for (int i = 0; i < maxIterations; i++) {
    zImag = 2 * zReal * zImag + cImag;
    zReal = zReal2 - zImag2 + cReal;

    zReal2 = zReal * zReal;
    zImag2 = zImag * zImag;

    iterations += (zReal2 + zImag2) <= 4.0;
  }

  finalIterations[hook(2, globalId)] = iterations;
}