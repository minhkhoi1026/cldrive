//{"dst":1,"src":0,"wg_local_x":2,"wg_local_y":3,"wg_local_z":4}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_workgroup_broadcast_1D_int(global int* src, global int* dst, unsigned int wg_local_x, unsigned int wg_local_y, unsigned int wg_local_z) {
  unsigned int offset = 0;
  unsigned int index = offset + get_global_id(0);

  int val = src[hook(0, index)];
  int broadcast_val = work_group_broadcast(val, wg_local_x);
  dst[hook(1, index)] = broadcast_val;
}