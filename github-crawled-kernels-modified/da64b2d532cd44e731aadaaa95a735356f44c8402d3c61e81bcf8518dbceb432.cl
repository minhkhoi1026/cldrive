//{"factor":1,"result":2,"size":3,"vec":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void cpu_mult(global const float16* vec, float factor, global float16* result, unsigned int size) {
  for (unsigned int i = get_global_id(0); i < size / 16; i += get_global_size(0))
    result[hook(2, i)] = vec[hook(0, i)] * factor;
}