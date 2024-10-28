//{"dst":0,"groupCounters":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void simple_kernel_5(global unsigned int* dst) {
  atomic_inc(dst);
  unsigned int groupIdX = get_group_id(0);
  unsigned int groupIdY = get_group_id(1);
  unsigned int groupIdZ = get_group_id(2);

  unsigned int groupCountX = get_num_groups(0);
  unsigned int groupCountY = get_num_groups(1);
  unsigned int groupCountZ = get_num_groups(2);

  global unsigned int* groupCounters = dst + 1;

  unsigned int destination = groupIdZ * groupCountY * groupCountX + groupIdY * groupCountX + groupIdX;
  atomic_inc(&groupCounters[hook(1, destination)]);
}