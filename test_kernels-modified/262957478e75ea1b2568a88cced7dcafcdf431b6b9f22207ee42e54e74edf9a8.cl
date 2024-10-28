//{"alignmentOffset":3,"destBuffer":2,"offsets":1,"srcValues":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fn3(global float3* srcValues, global unsigned int* offsets, global float* destBuffer, unsigned int alignmentOffset) {
  int tid = get_global_id(0);
  if ((tid & 3) == 0) {
    vstore3(srcValues[hook(0, 3 * (tid >> 2))], offsets[hook(1, tid)], destBuffer + alignmentOffset);
  } else {
    vstore3(vload3(tid, (global float*)srcValues), offsets[hook(1, tid)], destBuffer + alignmentOffset);
  }
}