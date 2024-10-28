//{"array":0,"stride":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void Reduction_InterleavedAddressing(global unsigned int* array, unsigned int stride) {
  unsigned int pos = get_global_id(0) * stride * 2;

  array[hook(0, pos)] = array[hook(0, pos)] + array[hook(0, pos + stride)];
}