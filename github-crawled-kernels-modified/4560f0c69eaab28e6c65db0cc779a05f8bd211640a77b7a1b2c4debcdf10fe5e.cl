//{"size":1,"vec":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void clear(global float* vec, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0))
    vec[hook(0, i)] = 0;
}