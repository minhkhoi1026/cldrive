//{"blockLength":4,"blockNumberMap":3,"channelMap":2,"in":0,"maxBlockNum":5,"out":1}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
float2 complexMul(const float2 A, const float2 B) {
  float2 C;
  C.s0 = A.s0 * B.s0 - (A.s1 * B.s1);
  C.s1 = A.s0 * B.s1 + B.s0 * A.s1;

  return C;
}

kernel void amdSigHistoryInsertMultiChan(global const float* in, global float* out, global const int* channelMap, global const int* blockNumberMap, int blockLength, int maxBlockNum) {
  int i = get_global_id(0);
  int n = get_global_id(1);
  int ch = channelMap[hook(2, n)];
  int startBlock = blockNumberMap[hook(3, n)];

  int inIndex = n * blockLength + i;
  int outIndex = ch * blockLength * maxBlockNum + startBlock * blockLength + i;

  if (n == 1 && ((i < 5))) {
  }

  out[hook(1, outIndex)] = in[hook(0, inIndex)];
}