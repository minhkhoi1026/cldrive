//{"size":1,"vec":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reverse_inplace(global float* vec, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < (size >> 1); i += get_global_size(0)) {
    float val1 = vec[hook(0, i)];
    float val2 = vec[hook(0, size - i - 1)];

    vec[hook(0, i)] = val2;
    vec[hook(0, size - i - 1)] = val1;
  }
}