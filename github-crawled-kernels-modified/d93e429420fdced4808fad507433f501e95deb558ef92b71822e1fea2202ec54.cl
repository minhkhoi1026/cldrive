//{"_atomics":4,"_constant_region":2,"_frame_base":1,"_heap_base":0,"_local_region":3,"frame":5,"inputA":7,"inputB":8,"output":6}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void add(global uchar* _heap_base, ulong _frame_base, constant uchar* _constant_region, local uchar* _local_region, global int* _atomics) {
  global ulong* frame = (global ulong*)&_heap_base[hook(0, _frame_base)];
  ulong4 args = vload4(0, &frame[hook(5, 3)]);

  global double* inputA = (global int*)(args.x + 24);
  global double* inputB = (global int*)(args.y + 24);
  global double* output = (global int*)(args.z + 24);

  size_t idx = get_global_id(0);
  output[hook(6, idx)] = inputA[hook(7, idx)] + inputB[hook(8, idx)];
}