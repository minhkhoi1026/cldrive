//{"histogram":1,"histogramPartial":0,"num_groups":2,"tmp_histogram":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram_sum_partial(global unsigned int* histogramPartial, global unsigned int* histogram, const unsigned int num_groups) {
  int tid = (int)get_global_id(0);
  int group_indx;
  int n = num_groups;

  local unsigned int tmp_histogram[256];
  tmp_histogram[hook(3, tid)] = histogramPartial[hook(0, tid)];

  group_indx = 256;
  while (--n > 1) {
    tmp_histogram[hook(3, tid)] = tmp_histogram[hook(3, tid)] + histogramPartial[hook(0, group_indx + tid)];
    group_indx += 256;
  }
  histogram[hook(1, tid)] = tmp_histogram[hook(3, tid)];
}