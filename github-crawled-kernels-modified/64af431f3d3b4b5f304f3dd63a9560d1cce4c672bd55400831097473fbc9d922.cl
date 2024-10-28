//{"cImags":1,"cReals":0,"finalIterations":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void iterate_points(constant const float* cReals, constant const float* cImags, global int* finalIterations) {
  int globalId = (int)get_global_id(0);

  float cReal = cReals[hook(0, globalId)];
  float cImag = cImags[hook(1, globalId)];

  float zReal = 0;
  float zImag = 0;

  float zReal2 = 0;
  float zImag2 = 0;

  int iterations = 0;

  for (int i = 0; i < 15 * 1000 * 1000; i++) {
    zImag = 2 * zReal * zImag + cImag;
    zReal = zReal2 - zImag2 + cReal;

    zReal2 = zReal * zReal;
    zImag2 = zImag * zImag;

    iterations += (zReal2 + zImag2) <= 4.0f;
  }

  finalIterations[hook(2, globalId)] = iterations;
}