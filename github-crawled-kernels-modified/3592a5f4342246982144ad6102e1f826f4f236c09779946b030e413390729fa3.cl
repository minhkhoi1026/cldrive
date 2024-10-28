//{"outB":2,"outG":1,"outR":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mandle(global char* outR, global char* outG, global char* outB) {
  int idx = get_global_id(0);
  int idy = get_global_id(1);

  float cx = (-2.5f + idx * ((1.5f - -2.5f) / 8192));
  float cy = (-2.0f + idy * ((2.0f - -2.0f) / 8192));

  int iter = 0;
  if (cy < 0)
    cy *= -1;
  if (cy < ((2.0f - -2.0f) / 8192) / 2)
    cy = 0;

  float zx = 0.0;
  float zy = 0.0;
  float z2x = zx * zx;
  float z2y = zy * zy;
  while (iter < 2000 && ((z2x + z2y) < 4)) {
    zy = 2 * zx * zy + cy;
    zx = z2x - z2y + cx;
    z2x = zx * zx;
    z2y = zy * zy;
    iter++;
  }
  outR[hook(0, idy * 8192 + idx)] = 1;
  outG[hook(1, idy * 8192 + idx)] = 1;
  outB[hook(2, idy * 8192 + idx)] = 1;

  if (iter < 2000) {
    outR[hook(0, idy * 8192 + idx)] = 255;
    outG[hook(1, idy * 8192 + idx)] = 255;
    outB[hook(2, idy * 8192 + idx)] = 255;
  }
}