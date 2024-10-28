//{"v1":0,"v1_inc":2,"v1_size":3,"v1_start":1,"v2":4,"v2_inc":6,"v2_size":7,"v2_start":5}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void recombineMutationStrengthWithAverage(global float* v1, unsigned int v1_start, unsigned int v1_inc, unsigned int v1_size, global const float* v2, unsigned int v2_start, unsigned int v2_inc, unsigned int v2_size) {
  for (unsigned int i = get_global_id(0); i < v1_size && i < v2_size; i += get_global_size(0)) {
    v1[hook(0, i * v1_inc + v1_start)] += v2[hook(4, i * v2_inc + v2_start)];
    v1[hook(0, i * v1_inc + v1_start)] /= 2;
  }
}