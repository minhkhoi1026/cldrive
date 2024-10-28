//{"blockLength":4,"blockOffset":3,"inIR":1,"inSignal":0,"maxBlockNum":5,"out":2}
int hook(int argId, int id) {
	int gID = get_global_id(0);
	printf("%d,%d,%d\n", gID, argId, id);
	return id;
}
kernel void amdMADFFTBlock(global const float* inSignal, global const float* inIR, global float* out, int blockOffset, int blockLength, int maxBlockNum) {
  int glbl_id = get_global_id(0);

  int inIndex = (glbl_id + blockOffset * blockLength) % (maxBlockNum * blockLength);

  out[hook(2, glbl_id)] = inIR[hook(1, glbl_id)] * inSignal[hook(0, inIndex)];
}