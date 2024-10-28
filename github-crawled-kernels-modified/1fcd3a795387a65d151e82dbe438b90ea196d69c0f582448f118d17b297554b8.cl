//{"Vq":3,"Xfirst":1,"Xsecond":2,"Xv":0,"info":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void linear_interpolation_GPU(global float* Xv, global float* Xfirst, global float* Xsecond, global float* Vq, global int* info) {
  int pos = get_global_id(0);

  int XVsize = info[hook(4, 0)];
  float item = log10(Xv[hook(0, pos)]);
  for (int i = 0; i < XVsize; i++) {
    if (item < Xfirst[hook(1, i)]) {
      if (i != XVsize - 1) {
        float delta = (item - Xfirst[hook(1, i)]) / (Xfirst[hook(1, i + 1)] - Xfirst[hook(1, i)]);
        Vq[hook(3, pos)] = delta * Xsecond[hook(2, i + 1)] + (1 - delta) * Xsecond[hook(2, i)];
        return;
      }
    }
  }
  Vq[hook(3, pos)] = Xsecond[hook(2, XVsize - 1)];

  return;
}