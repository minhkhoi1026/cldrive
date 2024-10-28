//{"in":1,"iteration":0,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void prefixSumStep(int iteration, global int* in, global int* out) {
  size_t i = get_global_id(0);
  int j = (int)exp2((float)iteration);
  if (i >= j)
    out[hook(2, i)] = in[hook(1, i)] + in[hook(1, i - j)];
  else
    out[hook(2, i)] = in[hook(1, i)];
}