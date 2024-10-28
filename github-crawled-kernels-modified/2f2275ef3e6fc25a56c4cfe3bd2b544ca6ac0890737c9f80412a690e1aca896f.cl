//{"imageIn1":0,"imageIn2":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void display_sRGB(global double* imageIn1, global double* imageIn2) {
 private
  double a = 0.055;
 private
  double thr = 0.04045;

  int i = get_global_id(0);

 private
  double value1 = imageIn1[hook(0, i)];
 private
  double value2 = imageIn2[hook(1, i)];

  if (value1 > thr)
    imageIn1[hook(0, i)] = 99.0 * pow((value1 + a) / (1.0 + a), 2.4) + 1.0;
  else
    imageIn1[hook(0, i)] = 99.0 * (value1 / 12.92) + 1.0;

  if (value2 > thr)
    imageIn2[hook(1, i)] = 99.0 * pow((value2 + a) / (1.0 + a), 2.4) + 1.0;
  else
    imageIn2[hook(1, i)] = 99.0 * (value2 / 12.92) + 1.0;

  return;
}