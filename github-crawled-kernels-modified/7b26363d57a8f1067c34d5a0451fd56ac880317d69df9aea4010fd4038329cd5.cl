//{"T":0,"T_offset":1,"ldt":2,"sum":10,"t":3,"t_offset":4,"tau":7,"tau_offset":8,"x":9,"y":5,"y_offset":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
void zsum_reduce(int n, int i, local double* x);
void zsum_reduce(int n, int i, local double* x) {
  barrier(0x01);
  if (n > 128) {
    if (i < 128 && i + 128 < n) {
      x[hook(9, i)] += x[hook(9, i + 128)];
    }
    barrier(0x01);
  }
  if (n > 64) {
    if (i < 64 && i + 64 < n) {
      x[hook(9, i)] += x[hook(9, i + 64)];
    }
    barrier(0x01);
  }
  if (n > 32) {
    if (i < 32 && i + 32 < n) {
      x[hook(9, i)] += x[hook(9, i + 32)];
    }
    barrier(0x01);
  }
  if (n > 16) {
    if (i < 16 && i + 16 < n) {
      x[hook(9, i)] += x[hook(9, i + 16)];
    }
    barrier(0x01);
  }
  if (n > 8) {
    if (i < 8 && i + 8 < n) {
      x[hook(9, i)] += x[hook(9, i + 8)];
    }
    barrier(0x01);
  }
  if (n > 4) {
    if (i < 4 && i + 4 < n) {
      x[hook(9, i)] += x[hook(9, i + 4)];
    }
    barrier(0x01);
  }
  if (n > 2) {
    if (i < 2 && i + 2 < n) {
      x[hook(9, i)] += x[hook(9, i + 2)];
    }
    barrier(0x01);
  }
  if (n > 1) {
    if (i < 1 && i + 1 < n) {
      x[hook(9, i)] += x[hook(9, i + 1)];
    }
    barrier(0x01);
  }
}

kernel void magma_dtrmv_kernel2(global double* T, int T_offset, int ldt, global double* t, int t_offset, global double* y, int y_offset, global double* tau, int tau_offset) {
  T += T_offset;
  t += t_offset;
  y += y_offset;
  tau += tau_offset;

  const int i = get_local_id(0);
  T += get_group_id(0);

  local double sum[128];

  sum[hook(10, i)] = T[hook(0, i * ldt)] * t[hook(3, i)];
  zsum_reduce(get_local_size(0), i, sum);

  barrier(0x01);

  if (i == 0) {
    y[hook(5, get_group_id(0))] = sum[hook(10, 0)];
    if (get_group_id(0) == 0)
      y[hook(5, get_num_groups(0))] = tau[hook(7, 0)];
  }
}