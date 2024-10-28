//{"acc":0,"lacc":2,"x":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
inline float work_group_reduction_sum(float* lacc, const float value) {
  const unsigned int local_id = get_local_id(0);

  lacc[hook(2, local_id)] = value;

  work_group_barrier(0x01);

  float pacc = value;
  unsigned int i = get_local_size(0);
  while (i > 0) {
    const bool include_odd = (i > ((i >> 1) << 1)) && (local_id == ((i >> 1) - 1));
    i >>= 1;
    if (include_odd) {
      pacc += lacc[hook(2, local_id + i + 1)];
    }
    if (local_id < i) {
      pacc += lacc[hook(2, local_id + i)];
      lacc[hook(2, local_id)] = pacc;
    }
    work_group_barrier(0x01);
  }

  return lacc[hook(2, 0)];
}

inline float work_group_reduction_sum_2(float* lacc, const float value) {
  const unsigned int local_row = get_local_id(0);
  const unsigned int local_col = get_local_id(1);
  const unsigned int local_m = get_local_size(0);

  lacc[hook(2, local_row + local_col * local_m)] = value;

  work_group_barrier(0x01);

  float pacc = value;
  unsigned int i = get_local_size(1);
  while (i > 0) {
    const bool include_odd = (i > ((i >> 1) << 1)) && (local_col == ((i >> 1) - 1));
    i >>= 1;
    if (include_odd) {
      pacc += lacc[hook(2, local_row + (local_col + i + 1) * local_m)];
    }
    if (local_col < i) {
      pacc += lacc[hook(2, local_row + (local_col + i) * local_m)];
      lacc[hook(2, local_row + local_col * local_m)] = pacc;
    }
    work_group_barrier(0x01);
  }

  return lacc[hook(2, local_row)];
}

kernel void sum_reduce(global float* acc, global const float* x) {
  const float sum = work_group_reduce_add(x[hook(1, get_global_id(0))]);
  if (get_local_id(0) == 0) {
    acc[hook(0, get_group_id(0))] = sum;
  }
}