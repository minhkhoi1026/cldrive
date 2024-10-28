//{"blockLength":4,"blockOffset":3,"inIR":1,"inSignal":0,"maxBlockNum":5,"out":2}
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

kernel void amdMADAccBlocks(global const float2* inSignal, global const float2* inIR, global float2* out, int blockOffset, int blockLength, int maxBlockNum) {
  int glbl_id = 2 * get_global_id(0);
  int inSigIndex = glbl_id + blockOffset * blockLength;
  int inIRIndex = glbl_id;

  out[hook(2, glbl_id / 2)] = complexMul(inSignal[hook(0, inSigIndex / 2)], inIR[hook(1, inIRIndex / 2)]);
  for (int block = 1; block < maxBlockNum; block++) {
    inSigIndex = glbl_id + (blockOffset - block) * blockLength;
    inIRIndex = glbl_id + block * blockLength;
    if (inSigIndex < 0)
      inSigIndex += maxBlockNum * blockLength;
    if (inIRIndex > maxBlockNum * blockLength)
      inIRIndex -= maxBlockNum * blockLength;

    out[hook(2, glbl_id / 2)] += complexMul(inSignal[hook(0, inSigIndex / 2)], inIR[hook(1, inIRIndex / 2)]);
  }
}