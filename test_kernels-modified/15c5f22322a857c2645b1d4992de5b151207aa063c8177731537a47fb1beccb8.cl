//{"dst":0,"src":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_local_memory_barrier_2(global int* dst, local int* src) {
  src[hook(1, get_local_id(0))] = get_local_id(0);
  src[hook(1, get_local_size(0) + get_local_id(0))] = get_local_id(0);
  barrier(0x01);
  dst[hook(0, get_local_size(0) * (2 * get_group_id(0)) + get_local_id(0))] = src[hook(1, get_local_size(0) - (get_local_id(0) + 1))];
  dst[hook(0, get_local_size(0) * (2 * get_group_id(0) + 1) + get_local_id(0))] = src[hook(1, get_local_size(0) + get_local_size(0) - (get_local_id(0) + 1))];
}