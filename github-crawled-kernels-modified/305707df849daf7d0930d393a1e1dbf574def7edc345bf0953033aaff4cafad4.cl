//{"avrg":4,"doavrg":3,"ioim":0,"size":2,"tim":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void normdata(global float* ioim, global float* tim, int size, int doavrg, float avrg) {
  const int index = get_global_id(0);
  const int elnan = isnan(*(ioim + index));
  if (doavrg && !elnan)
    *(tim + index) *= avrg;
  else if (!doavrg && elnan)
    *(tim + index) /= avrg;
}