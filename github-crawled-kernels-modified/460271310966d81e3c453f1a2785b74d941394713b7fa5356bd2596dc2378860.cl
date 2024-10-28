//{"in":2,"num_entries":1,"out":3,"size":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int2 int2;
kernel __attribute__((reqd_work_group_size(1, 256, 1))) kernel void MatVecMulReduce(unsigned int size, unsigned int num_entries, global const float* in, global float* out) {
  unsigned int x = get_global_id(0);

  if (x < size) {
    float sum = 0;
    for (unsigned int i = 0; i < num_entries; i++)
      sum += in[hook(2, x * num_entries + i)];
    out[hook(3, x)] = sum;
  }
}