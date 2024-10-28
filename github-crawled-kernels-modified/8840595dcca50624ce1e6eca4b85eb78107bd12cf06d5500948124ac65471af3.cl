//{"float2":1,"size":2,"vec1":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void swap(global float* vec1, global float* float2, unsigned int size) {
  float tmp;
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0)) {
    tmp = float2[hook(1, i)];
    float2[hook(1, i)] = vec1[hook(0, i)];
    vec1[hook(0, i)] = tmp;
  }
}