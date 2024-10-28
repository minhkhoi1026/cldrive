//{"inputdata":0,"outputdata":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void exampleKernelFunction(global int* inputdata, global int* outputdata) {
  int loopindex = get_global_id(0);
  int offset = 1;
  outputdata[hook(1, loopindex)] = inputdata[hook(0, loopindex)] - offset;
}