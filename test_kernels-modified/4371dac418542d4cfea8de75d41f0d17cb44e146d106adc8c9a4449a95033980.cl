//{"_atomics":4,"_constant_region":2,"_frame":5,"_frame_base":1,"_heap_base":0,"_local_region":3}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void lookupBufferAddress(global uchar* _heap_base, ulong _frame_base, constant uchar* _constant_region, local uchar* _local_region, global int* _atomics) {
  global ulong* _frame = (global ulong*)&_heap_base[hook(0, _frame_base)];

  _frame[hook(5, 0)] = (ulong)_heap_base;
}