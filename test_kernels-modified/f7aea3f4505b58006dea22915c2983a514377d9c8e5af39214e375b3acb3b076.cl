//{"local_sums":2,"niters":0,"partial_sums":3,"step_size":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void pi(const int niters, const float step_size, local float* local_sums, global float* partial_sums) {
  int num_wrk_items = get_local_size(0);
  int local_id = get_local_id(0);
  int group_id = get_group_id(0);
  float x, sum, accum = 0.0f;
  int i, istart, iend;
  istart = (group_id * num_wrk_items + local_id) * niters;
  iend = istart + niters;
  for (i = istart; i < iend; i++) {
    x = (i + 0.5f) * step_size;
    accum += 4.0f / (1.0f + x * x);
  }
  local_sums[hook(2, local_id)] = accum;
  barrier(0x01);
  if (local_id == 0) {
    sum = 0.0f;
    for (i = 0; i < num_wrk_items; i++) {
      sum += local_sums[hook(2, i)];
    }
    partial_sums[hook(3, group_id)] = sum;
  }
}