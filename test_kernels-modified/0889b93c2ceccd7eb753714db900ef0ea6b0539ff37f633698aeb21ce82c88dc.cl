//{"size":1,"sum":2,"v":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void testSum(global float* v, unsigned int size, global float* sum) {
  float sum2 = 0;
  for (unsigned int i = get_global_id(0); i < size; i += get_global_size(0))
    sum2 += v[hook(0, i)];
  *sum += sum2;
}