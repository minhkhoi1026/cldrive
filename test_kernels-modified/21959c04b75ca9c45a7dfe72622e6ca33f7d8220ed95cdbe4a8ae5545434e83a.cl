//{"alignmentOffsets":2,"offsets":1,"results":3,"src":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_vload2(global int* src, global unsigned int* offsets, global unsigned int* alignmentOffsets, global int2* results) {
  int tid = get_global_id(0);
  int2 tmp = vload2(offsets[hook(1, tid)], ((global int*)src) + alignmentOffsets[hook(2, tid)]);
  results[hook(3, tid)] = tmp;
}