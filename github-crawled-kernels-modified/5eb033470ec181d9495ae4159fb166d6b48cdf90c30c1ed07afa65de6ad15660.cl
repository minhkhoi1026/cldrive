//{"blockLength":6,"blockNumberMap":5,"channelMap":3,"inIR":1,"inSignal":0,"maxBlockNum":7,"numSets":8,"out":2,"setMap":4}
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

kernel void amdMADAccBlocksMultiChan(global const float2* inSignal, global const float2* inIR, global float2* out, global const int* channelMap, global const int* setMap, global const int* blockNumberMap, int blockLength, int maxBlockNum, int numSets) {
  int i = get_global_id(0);
  int n = get_global_id(1);
  int ch = channelMap[hook(3, n)];
  int set = setMap[hook(4, n)];
  int startBlock = blockNumberMap[hook(5, n)];

  int inSigIndex = ch * blockLength * maxBlockNum + startBlock * blockLength + i;
  int inIRIndex = ((ch * numSets + set) * maxBlockNum) * blockLength + i;
  int outIndex = n * blockLength + i;

  if (n == 1 && ((i < 5))) {
  }

  out[hook(2, outIndex)] = complexMul(inSignal[hook(0, inSigIndex)], inIR[hook(1, inIRIndex)]);
  for (int block = 1; true && block < maxBlockNum; block++) {
    int curBlock = startBlock - block;
    if (curBlock < 0)
      curBlock += maxBlockNum;

    inSigIndex = ch * blockLength * maxBlockNum + curBlock * blockLength + i;
    inIRIndex = ((ch * numSets + set) * maxBlockNum + block) * blockLength + i;

    if (n == 0 && i == 0) {
    }

    out[hook(2, outIndex)] += complexMul(inSignal[hook(0, inSigIndex)], inIR[hook(1, inIRIndex)]);
  }
}