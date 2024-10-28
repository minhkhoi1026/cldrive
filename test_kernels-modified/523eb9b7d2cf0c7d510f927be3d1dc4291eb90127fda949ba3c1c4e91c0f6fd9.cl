//{"num_cities":1,"pop_len":0,"prob_mutation":4,"rnd_mutate_loc":6,"rnd_prob_mutation":5,"x_coord":2,"y_coord":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void mutate(int pop_len, int num_cities, global int* x_coord, global int* y_coord, float prob_mutation, global const float* rnd_prob_mutation, global const int* rnd_mutate_loc) {
  int tid = get_global_id(0);

  if (tid < pop_len) {
    if (rnd_prob_mutation[hook(5, tid)] < prob_mutation) {
      int loc0 = rnd_mutate_loc[hook(6, 2 * tid)];
      int loc1 = rnd_mutate_loc[hook(6, 2 * tid + 1)];
      int offset0 = tid * num_cities + loc0;
      int offset1 = tid * num_cities + loc1;

      int tmp = x_coord[hook(2, offset0)];
      x_coord[hook(2, offset0)] = x_coord[hook(2, offset1)];
      x_coord[hook(2, offset1)] = tmp;

      tmp = y_coord[hook(3, offset0)];
      y_coord[hook(3, offset0)] = y_coord[hook(3, offset1)];
      y_coord[hook(3, offset1)] = tmp;
    }
  }
}