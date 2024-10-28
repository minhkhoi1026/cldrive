//{"out":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test(global float* out) {
  int globalId = get_global_id(0);
  int localId = get_local_id(0);

  atomic_work_item_fence(0x02, memory_order_seq_cst, memory_scope_device);
  out[hook(0, globalId)] = out[hook(0, globalId)] + globalId;
}