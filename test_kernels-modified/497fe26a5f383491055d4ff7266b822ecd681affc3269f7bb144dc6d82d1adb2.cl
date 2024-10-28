//{"histogram":2,"num_groups":1,"partial_histogram":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void histogram_sum_partial_results_fp(global unsigned int* partial_histogram, int num_groups, global unsigned int* histogram) {
  int tid = (int)get_global_id(0);
  int group_id = (int)get_group_id(0);
  int group_indx;
  int n = num_groups;
  unsigned int tmp_histogram, tmp_histogram_first;

  int first_workitem_not_in_first_group = ((get_local_id(0) == 0) && group_id);

  tid += group_id;
  int tid_first = tid - 1;
  if (first_workitem_not_in_first_group)
    tmp_histogram_first = partial_histogram[hook(0, tid_first)];

  tmp_histogram = partial_histogram[hook(0, tid)];

  group_indx = 257 * 3;
  while (--n > 0) {
    if (first_workitem_not_in_first_group)
      tmp_histogram_first += partial_histogram[hook(0, tid_first)];

    tmp_histogram += partial_histogram[hook(0, group_indx + tid)];
    group_indx += 257 * 3;
  }

  if (first_workitem_not_in_first_group)
    histogram[hook(2, tid_first)] = tmp_histogram_first;
  histogram[hook(2, tid)] = tmp_histogram;
}