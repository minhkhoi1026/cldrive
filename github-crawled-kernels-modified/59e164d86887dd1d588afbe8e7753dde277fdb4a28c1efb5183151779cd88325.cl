//{"input":0,"output":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mergePrefixSums(global unsigned int* input, global unsigned int* output) {
  int gidx = get_global_id(0);
  int gidy = get_global_id(1);
  int gpos = gidy + (gidx << 8);
  output[hook(1, gpos)] += input[hook(0, gidy)];
}