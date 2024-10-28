//{"histogram":2,"num_groups":1,"partial_histogram":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram_sum_partial_results_unorm8(global unsigned int* partial_histogram, int num_groups, global unsigned int* histogram) {
  int tid = (int)get_global_id(0);
  int group_indx;
  int n = num_groups;
  unsigned int tmp_histogram;

  tmp_histogram = partial_histogram[hook(0, tid)];

  group_indx = 256 * 3;
  while (--n > 0) {
    tmp_histogram += partial_histogram[hook(0, group_indx + tid)];
    group_indx += 256 * 3;
  }

  histogram[hook(2, tid)] = tmp_histogram;
}