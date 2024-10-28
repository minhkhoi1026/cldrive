//{"alignmentOffset":3,"destBuffer":2,"dp":5,"offsets":1,"sPrivateStorage":4,"sp":6,"srcValues":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fn4(global uint2* srcValues, global unsigned int* offsets, global uint2* destBuffer, unsigned int alignmentOffset) {
 private
  uint2 sPrivateStorage[32];
  int tid = get_global_id(0);
  sPrivateStorage[hook(4, tid)] = (uint2)(unsigned int)0;

  vstore2(srcValues[hook(0, tid)], offsets[hook(1, tid)], ((private unsigned int*)sPrivateStorage) + alignmentOffset);

  unsigned int i;
 private
  unsigned int* sp = (private unsigned int*)(sPrivateStorage + offsets[hook(1, tid)]) + alignmentOffset;
  global unsigned int* dp = (global unsigned int*)(destBuffer + offsets[hook(1, tid)]) + alignmentOffset;
  for (i = 0; i < sizeof(sPrivateStorage[hook(4, 0)]) / sizeof(*sp); i++)
    dp[hook(5, i)] = sp[hook(6, i)];
}