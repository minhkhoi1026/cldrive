//{"a":2,"local_x":4,"local_y":5,"size":3,"x":0,"y":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
__attribute__((reqd_work_group_size(1, 1, 1))) kernel void SAXPY(global const float* restrict x, global float* restrict y, const int a, const int size) {
  __attribute__((xcl_dataflow)) for (int i = 0; i < size; i += 1024) {
    float local_x[1024];
    float local_y[1024];
    __attribute__((opencl_unroll_hint(16))) for (int j = 0; j < 1024; j++) {
      local_x[hook(4, j)] = x[hook(0, i + j)];
    }
    __attribute__((opencl_unroll_hint(16))) for (int j = 0; j < 1024; j++) {
      local_y[hook(5, j)] = y[hook(1, i + j)];
    }
    __attribute__((opencl_unroll_hint(16))) for (int j = 0; j < 1024; j++) {
      y[hook(1, j)] = a * local_x[hook(4, j)] + local_y[hook(5, j)];
    }
  }
}