//{"num_cols":1,"num_rows":0,"out":4,"v1":2,"v2":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
typedef int2 int2;
kernel __attribute__((reqd_work_group_size(1, 256, 1))) kernel __attribute__((reqd_work_group_size(256, 1, 1))) kernel void TransposedVecMul(unsigned int num_rows, unsigned int num_cols, global const float* v1, global const float* v2, global float* out) {
  unsigned int row = get_global_id(0);
  unsigned int col = get_global_id(1);

  if (row < num_rows && col < num_cols) {
    out[hook(4, row * num_cols + col)] = v1[hook(2, row)] * v2[hook(3, col)];
  }
}