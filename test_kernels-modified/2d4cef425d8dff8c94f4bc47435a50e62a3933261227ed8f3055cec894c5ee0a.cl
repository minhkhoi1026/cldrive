//{"inc1":2,"size1":3,"start1":1,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void reset_activations(global float* vec1, unsigned int start1, unsigned int inc1, unsigned int size1) {
  for (unsigned int i = get_global_id(0); i < size1; i += get_global_size(0))
    vec1[hook(0, i * inc1 + start1)] = 0;
}