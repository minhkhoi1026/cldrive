//{"input":1,"output":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void fractionize(global double* output, global double* input) {
  unsigned int tid = get_global_id(0);

  if (tid == 0)
    output[hook(0, tid)] = input[hook(1, tid)] / (double)((1 << 22) - 1) * 100;
}