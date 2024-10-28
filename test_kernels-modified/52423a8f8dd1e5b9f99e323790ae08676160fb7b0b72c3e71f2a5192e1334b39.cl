//{"blockLength":6,"in":0,"inLength":3,"inOffset":2,"out":1,"outLength":5,"outOffset":4,"padLength":7}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdPadFFTBlock(global const float* in, global float* out, int inOffset, int inLength, int outOffset, int outLength, int blockLength, int padLength) {
  int glbl_id = get_global_id(0);

  int blockNumber = (glbl_id) / (blockLength + padLength);
  int inIndex = ((glbl_id + inOffset - blockNumber * padLength) % inLength);
  int outIndex = ((glbl_id + outOffset) % outLength);

  bool isPad = (glbl_id % (blockLength + padLength)) >= blockLength;

  out[hook(1, outIndex)] = isPad ? 0 : in[hook(0, inIndex)];
}