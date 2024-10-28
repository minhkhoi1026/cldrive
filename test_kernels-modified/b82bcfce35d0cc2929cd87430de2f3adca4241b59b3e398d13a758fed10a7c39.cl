//{"fitness":1,"pop_len":0,"result_inx":5,"result_val":4,"scratch_inx":3,"scratch_val":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void max_fit_phase_0(int pop_len, global float* fitness, local float* scratch_val, local int* scratch_inx, global float* result_val, global int* result_inx) {
  int ginx = get_global_id(0);
  int max_index;
  float accumulator = -(__builtin_inff());

  while (ginx < pop_len) {
    float element = fitness[hook(1, ginx)];
    if (element > accumulator) {
      accumulator = element;
      max_index = ginx;
    }
    ginx += get_global_size(0);
  }

  int linx = get_local_id(0);
  scratch_val[hook(2, linx)] = accumulator;
  scratch_inx[hook(3, linx)] = max_index;
  barrier(0x01);

  for (int offset = get_local_size(0) / 2; offset > 0; offset /= 2) {
    if (linx < offset) {
      float other = scratch_val[hook(2, linx + offset)];
      float mine = scratch_val[hook(2, linx)];
      if (other > mine) {
        scratch_val[hook(2, linx)] = other;
        scratch_inx[hook(3, linx)] = scratch_inx[hook(3, linx + offset)];
      }
    }
    barrier(0x01);
  }
  if (linx == 0) {
    int gid = get_group_id(0);
    result_val[hook(4, gid)] = scratch_val[hook(2, 0)];
    result_inx[hook(5, gid)] = scratch_inx[hook(3, 0)];
  }
}