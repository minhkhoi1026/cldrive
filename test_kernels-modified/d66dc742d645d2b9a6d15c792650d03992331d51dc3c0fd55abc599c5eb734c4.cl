//{"array":0,"stride":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduction_SequentialAddressing(global unsigned int* array, unsigned int stride) {
  int GID = get_global_id(0);
  array[hook(0, GID)] += array[hook(0, GID + stride)];
}