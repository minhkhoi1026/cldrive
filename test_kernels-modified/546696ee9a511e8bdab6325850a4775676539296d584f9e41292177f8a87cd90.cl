//{"test_indices_removed_from_all_buffers":1,"test_patterns":2,"test_patterns_subset_tmp":3,"total_number_test_indices_removed":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void do_generate_subset_test_patterns(int total_number_test_indices_removed, global int* test_indices_removed_from_all_buffers, global float* test_patterns, global float* test_patterns_subset_tmp) {
  int tid = get_global_id(0);
  if (tid >= total_number_test_indices_removed) {
    return;
  }

  int test_idx = test_indices_removed_from_all_buffers[hook(1, tid)];

  int j;
  for (j = 0; j < 3; j++) {
    test_patterns_subset_tmp[hook(3, j * total_number_test_indices_removed + tid)] = test_patterns[hook(2, test_idx * 3 + j)];
  }
}