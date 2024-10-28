//{"alignmentOffset":3,"destBuffer":2,"dp":5,"offsets":1,"sPrivateStorage":4,"sp":6,"srcValues":0}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void test_fn(global char2* srcValues, global unsigned int* offsets, global char2* destBuffer, unsigned int alignmentOffset) {
 private
  char2 sPrivateStorage[128];
  int tid = get_global_id(0);
  sPrivateStorage[hook(4, tid)] = (char2)(char)0;

  vstore2(srcValues[hook(0, tid)], offsets[hook(1, tid)], ((private char*)sPrivateStorage) + alignmentOffset);

  unsigned int i;
 private
  char* sp = (private char*)(sPrivateStorage + offsets[hook(1, tid)]) + alignmentOffset;
  global char* dp = (global char*)(destBuffer + offsets[hook(1, tid)]) + alignmentOffset;
  for (i = 0; i < sizeof(sPrivateStorage[hook(4, 0)]) / sizeof(*sp); i++)
    dp[hook(5, i)] = sp[hook(6, i)];
}