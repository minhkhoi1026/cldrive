//{"dst":0,"src0":1,"src1":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void compiler_local_memory_two_ptr(global int* dst, local int* src0, local int* src1) {
  src0[hook(1, get_local_id(0))] = get_local_id(0);
  src1[hook(2, get_local_id(0))] = get_global_id(0);
  barrier(0x01);
  dst[hook(0, get_global_id(0))] = src0[hook(1, 15 - get_local_id(0))] + src1[hook(2, 15 - get_local_id(0))];
}