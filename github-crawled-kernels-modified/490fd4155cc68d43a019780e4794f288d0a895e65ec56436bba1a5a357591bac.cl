//{"alignmentOffset":3,"destBuffer":2,"dp":5,"offsets":1,"sPrivateStorage":4,"sp":6,"srcValues":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fn5(global float2* srcValues, global unsigned int* offsets, global float2* destBuffer, unsigned int alignmentOffset) {
 private
  float2 sPrivateStorage[32];
  int tid = get_global_id(0);
  sPrivateStorage[hook(4, tid)] = (float2)(float)0;

  vstore2(srcValues[hook(0, tid)], offsets[hook(1, tid)], ((private float*)sPrivateStorage) + alignmentOffset);

  unsigned int i;
 private
  float* sp = (private float*)(sPrivateStorage + offsets[hook(1, tid)]) + alignmentOffset;
  global float* dp = (global float*)(destBuffer + offsets[hook(1, tid)]) + alignmentOffset;
  for (i = 0; i < sizeof(sPrivateStorage[hook(4, 0)]) / sizeof(*sp); i++)
    dp[hook(5, i)] = sp[hook(6, i)];
}