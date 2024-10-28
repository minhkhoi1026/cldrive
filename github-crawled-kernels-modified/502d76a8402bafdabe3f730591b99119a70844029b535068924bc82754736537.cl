//{"dst":1,"src":0,"wg_local_x":2,"wg_local_y":3,"wg_local_z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_workgroup_broadcast_3D_int(global int* src, global int* dst, unsigned int wg_local_x, unsigned int wg_local_y, unsigned int wg_local_z) {
  unsigned int lsize = get_local_size(0) * get_local_size(1) * get_local_size(2);
  unsigned int offset = get_group_id(0) * lsize + get_group_id(1) * get_num_groups(0) * lsize + get_group_id(2) * get_num_groups(1) * get_num_groups(0) * lsize;
  unsigned int index = offset + get_local_id(0) + get_local_id(1) * get_local_size(0) + get_local_id(2) * get_local_size(1) * get_local_size(0);

  int val = src[hook(0, index)];
  int broadcast_val = work_group_broadcast(val, wg_local_x, wg_local_y, wg_local_z);
  dst[hook(1, index)] = broadcast_val;
}