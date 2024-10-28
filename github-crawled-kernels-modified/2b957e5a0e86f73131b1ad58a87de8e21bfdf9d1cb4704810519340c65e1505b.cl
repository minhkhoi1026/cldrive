//{"fit_prob":1,"pop_size":0,"rand_nums":2,"sel_ix":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void select_parents(int pop_size, global float* fit_prob, global float* rand_nums, global int* sel_ix) {
  int tid = get_global_id(0);

  if (tid < (2 * pop_size)) {
    for (int i = 0; i < pop_size; i++) {
      if (rand_nums[hook(2, tid)] < fit_prob[hook(1, i)]) {
        sel_ix[hook(3, tid)] = i;
        break;
      }
    }
  }
}