//{"flag":2,"in":1,"referenceDistance":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void _check_normalization(double referenceDistance, global double* in, global int* flag) {
  int globalID = get_global_id(0);

  if ((in[hook(1, globalID + 1)] - in[hook(1, globalID)]) != referenceDistance) {
    flag[hook(2, 0)] = 1;
  }
}