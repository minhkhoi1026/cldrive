//{"A":0,"B":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void matrix_test1(global int* A, global int* B) {
  int local_id_x = get_local_id(0);
  int local_id_y = get_local_id(1);

  int global_id_x = get_global_id(0);
  int global_id_y = get_global_id(1);

  int work_dim = get_work_dim();
  int global_size = get_global_size(0);
  int num_groups = get_num_groups(0);

  int group_id_x = get_group_id(0);
  int group_id_y = get_group_id(1);

  int local_size = get_local_size(0);

  A[hook(0, global_id_x * global_size + global_id_y)] = group_id_x * num_groups + group_id_y;
  B[hook(1, global_id_x * global_size + global_id_y)] = local_id_x * local_size + local_id_y;
}